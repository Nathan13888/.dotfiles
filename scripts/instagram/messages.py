import json
import os
import time
import sys
import re
from collections import defaultdict

SPEC_REGEX=r'^(?!([A-Za-z0-9\s\%\!@#\$\^&\*\%\-\(\)\<\>\,\.\{\}\[\]:;\'\"\?\~\`\\\/\_\+\=“”\~\|]+))'

# TODO: re-encode all json files
def read(path):
  with open(path, 'r') as f:
    return json.load(f)

class Chat:
  path=""
  total_messages=0
  senders={}
  total_photos=0
  total_videos=0
  total_audio=0

def process(path):
  pp={}

  # messages
  for (dirpath, dirnames, filenames) in os.walk(path):
    for filename in filenames:
      # analyze all messages*.json files
      if filename.endswith('.json') and filename.startswith('message'): 
        msg_file=os.sep.join([dirpath, filename])
        #print(f'Processing {msg_file}')
        data=read(msg_file)

        # Prime participants
        for p in data['participants']:
          if not p['name'] in pp:
            pp[p['name']]={
              "avg_char_per_message": 0,
              "total_char": 0,
              "total_messages": 0,
              "extra_msgs": 0,
              #"msg_time": [ 0 for i in range(24) ],
              "msg_time": dict(zip([ i for i in range(24)],[ 0 for i in range(24)])),
              "msg_year": defaultdict(lambda: 0),
              "reactions": defaultdict(lambda: 0),
              "special_chars": defaultdict(lambda: 0),
            }

        for m in data['messages']:
          if 'content' in m and 'sender_name' in m:
            if m['content']=='Liked a message' or m['content'].startswith('Reacted '):
              # not a user typed message
              if m['sender_name'] in pp:
                pp[m['sender_name']]['extra_msgs']+=1
            else:
              msg=m['content'].encode('latin1').decode()
              #print(msg)
              if m['sender_name'] in pp:
                for thing in [w for w in msg if re.search(SPEC_REGEX, w)]:
                  pp[m['sender_name']]['special_chars'][thing] += 1
                pp[m['sender_name']]['total_char']+=len(msg)
                pp[m['sender_name']]['total_messages']+=1
                if 'timestamp_ms' in m:
                  t=time.localtime(m['timestamp_ms']/1000)
                  pp[m['sender_name']]['msg_time'][t.tm_hour]+=1
                  year = t.tm_year
                  pp[m['sender_name']]['msg_year'][year]+=1

            if 'reactions' in m:
              for r in m['reactions']:
                if r['actor'] in pp:
                  reaction=r['reaction'].encode('latin1').decode()
                  #print(pp[r['actor']]['reactions'])
                  #print(reaction)
                  pp[r['actor']]['reactions'][reaction]+=1
  tt=0
  for p in pp:
    total_messages=pp[p]['total_messages']
    if total_messages > 0:
      pp[p]['avg_char_per_message']=int(pp[p]['total_char']/total_messages*100)/100
      tt+=total_messages
      pp[p]['reactions']={k: v for k, v in sorted(pp[p]['reactions'].items(), key=lambda item: item[1], reverse=True)}
      pp[p]['special_chars']={k: v for k, v in sorted(pp[p]['special_chars'].items(), key=lambda item: item[1], reverse=True)}


  c=Chat()
  c.path=path
  c.senders=pp
  c.total_messages=tt

  return c

if __name__ == "__main__":
  inboxes = []
  if len(sys.argv)<=1:
    directories = [ f.path for f in os.scandir('inbox') if f.is_dir() ] + [ f.path for f in os.scandir('message_requests') if f.is_dir() ]
    inboxes = [ process(i) for i in directories ]
  else:
    inboxes = [ process(i) for i in sys.argv[1:] ]

  total_messages = { k:v for k, v in zip([ (i.path.split("/")[-1] if hasattr(i,'path') else None ) for i in inboxes], [ i.total_messages for i in inboxes ]) }
  most_messages = {k:v for k, v in sorted(total_messages.items(), key=lambda item: item[1], reverse=False)}
  obj={
    "inboxes": [ i.__dict__ for i in inboxes ],
    "most_messages": most_messages,
  }
  print(json.dumps(obj, ensure_ascii=False))

