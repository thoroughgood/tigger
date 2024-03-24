#!/bin/dash
PATH="$PATH:$(pwd)"

for i in $(seq 0 9);
do
    ./test0$i.sh
done
