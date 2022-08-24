import json

def read(path):
  with open(path, 'r') as f:
    return json.load(f)

def process(obj):
  t=[]
  for f in obj:
    t.append(f['string_list_data'][0]['value'])
  return t

followers=process(read('./followers.json')['relationships_followers'])
following=process(read('./following.json')['relationships_following'])

#print(followers)
#print(following)

def back(name):
  for y in followers:
    if name==y:
      return True
  return False

for x in following:
  if back(x)==False:
    print(f'No follow back: {x}')
