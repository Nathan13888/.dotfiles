#!/bin/sh

# TODO: customizable editor, shell mode

NEED_TERM=true
#USE_THIS_SHELL=false

if [ command -v goneovim &> /dev/null ]; then
    EDITOR="goneovim"
    NEED_TERM=false
else
    if ! command -v $EDITOR &> /dev/null; then
        EDITOR="$(command -v vi)"
    fi
fi

EDITOR="$(which $EDITOR)"

TERM="not found"

if [[ $NEED_TERM = true ]] && [[ $USER_THIS_SHELL != false ]] ; then
    if [[ ! -x "$TERMINAL" ]] ; then
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

FILE="$HOME/TODO.md"

function open {
    #echo PATH: $PATH
    CMD="$EDITOR $FILE"
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
        open
        ;;
    *)
        echo "Missing parameters :("
        exit 1
        ;;
esac

