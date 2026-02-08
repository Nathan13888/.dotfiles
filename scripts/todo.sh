#!/bin/bash

NEED_TERM=true
#USE_THIS_SHELL=false

if [ command -v neovide ] &>/dev/null; then
  EDITOR="neovide"
  NEED_TERM=false
else
  if ! command -v $EDITOR &>/dev/null; then
    EDITOR="$(command -v vi)"
  fi
fi

EDITOR="$(which $EDITOR)"

TERM="not found"

if [[ $NEED_TERM = true ]] && [[ $USER_THIS_SHELL != false ]]; then
  if [[ ! -x "$TERMINAL" ]]; then
    TERM="$(which $TERMINAL)"
  else
    echo "Cannot find appropriate terminal"
    exit 1
  fi
fi

echo -e "Using editor:\t\t\t$EDITOR"
echo -e "Using terminal (if needed):\t$TERM"
echo -e "Needs terminal:\t\t\t$NEED_TERM"
echo -e "Use this shell:\t\t\t$USE_THIS_SHELL"

#BASE_DIR="$HOME/.todo"
BASE_DIR="$HOME/.notable/notes"

function open {
  #echo PATH: $PATH
  CMD="$EDITOR -p $@"
  echo -e "Using command:\t\t\t$CMD"
  if [[ $NEED_TERM = true ]]; then
    if [[ $USE_THIS_SHELL = true ]]; then
      $CMD
    else
      2>/dev/null 1>&2 $TERM -e $CMD &
      disown
    fi
  else
    2>/dev/null 1>&2 $CMD &
    disown
  fi
}

case "$1" in
  open)
    if ! [ -d "$BASE_DIR" ]; then
      echo "'$BASE_DIR' not found. Creating directory."
      mkdir $BASE_DIR
    fi
    LISTS=${@:2}
    if [ "$#" -eq 1 ]; then
      # TODO: auto find all "default" files and extraneous files
      LISTS="main school uni setup dev homelab 3dprinter projects house food volunteering garden review shopping"
    fi
    echo $LISTS
    PATHS=()
    for list in $LISTS; do
      PATHS+=("$BASE_DIR/${list^^}.md")
    done
    echo "Opening the following lists:"
    for path in "${PATHS[@]}"; do
      echo -e "\t- $path"
    done
    open ${PATHS[@]}
    ;;
  *)
    echo "Missing parameters :("
    exit 1
    ;;
esac
