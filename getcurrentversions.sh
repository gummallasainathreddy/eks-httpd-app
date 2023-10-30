#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file
> $output_file

for i in $(find . -type f -name "values.yaml"); do
    echo "-------------------------" >> $output_file
    echo "$i" >> $output_file
    echo "-------------------------" >> $output_file
    cat "$i" | grep 'imageTag\|#renovate' | sed -e 's/^[ \t]*//' >> $output_file
done
