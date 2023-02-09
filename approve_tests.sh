#!/bin/bash

echo Following contents will be written to the expected:
echo
echo

for x in ./tap_results/sql/*.sql; do
    base=$(basename $x)
    t=./expected/"${base%.sql}.out"
    echo "\unset ECHO" > $t
    echo >> $t
    cat "$x" >> $t
    echo "$t"
    cat "$t"
    echo
done

