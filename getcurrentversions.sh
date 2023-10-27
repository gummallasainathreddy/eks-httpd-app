#!/bin/bash

for i in $(find -name values.yaml); do
    echo "-------------------------"
    echo "$i"
    echo "-------------------------"
    cat "$i" | grep 'imageTag\|#renovate' | sed -e 's/^[ \t]*//'
done
