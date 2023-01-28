#!/bin/sh

RIME=$(readlink -f "$HOME/.local/share/fcitx5/rime")


confirm() {
    commit='';
    while :; do
        echo "> $1 [Yn]: ";
        read commit;
        ([ -z "$commit" ] || [ "$commit" = y ] || [ "$commit" = Y ] || [ "$commit" = n ]) && break;
    done;
    test "$commit" != n || exit;
}

if [ -d $RIME/build ]; then
    confirm "Delete /build?"
    rm -vr $RIME/build
else
    echo "/build directory not found"
fi

if [ -d $RIME/opencc ]; then
    confirm "Delete /opencc?"
    rm -vr $RIME/opencc
else
    echo "/opencc directory not found"
fi


for fd in $RIME/*; do
    f=$(basename $fd)
    if [ -f $f ]; then
        if [[ $f == *.custom.yaml || $f == installation.yaml || $f == key_bindings.yaml || $f == user.yaml ]]; then
            echo "SKIPPING... $f"
        else
            if [[ $f == *.yaml ]]; then
                echo "Deleting... $f"
            fi
        fi
    fi
done



