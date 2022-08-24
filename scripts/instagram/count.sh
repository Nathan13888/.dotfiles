#!/bin/sh

colNums=()

echo "=========================="

calc(){
    TOTAL="$(cat $FOLD/*.json|grep '"content"'|wc -l)"
    if [ $TOTAL -ge 2000 ]; then
        echo $FOLD
        echo "Total: $TOTAL"
        colNums="$colNums:$TOTAL"
        echo "=========================="
    fi
}

for FOLD in inbox/* ;do
    calc $FOLD
done

for FOLD in message_requests/* ;do
    calc $FOLD
done

sortedColNums=( $( printf "%s\n" "${colNums[@]}" | sort -n ))
echo $sortColNums

