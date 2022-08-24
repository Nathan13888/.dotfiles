#!/bin/sh

echo "=========================="

calc(){
    TOTAL="$(cat $FOLD/messages.csv|wc -l)"
    if [ $TOTAL -ge 2000 ]; then
        echo $FOLD
        echo "Total: $TOTAL"
        echo "=========================="
    fi
}

for FOLD in ./* ;do
    calc $FOLD
done
