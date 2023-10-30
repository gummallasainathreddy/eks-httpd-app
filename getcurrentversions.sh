#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file
> $output_file

for i in $(find . -type f -name "values.yaml"); do
    echo "-------------------------" >> $output_file
    echo "$i" >> $output_file
    echo "-------------------------" >> $output_file
    while IFS= read -r line; do
        if [[ $line =~ (imageTag|image|[#]renovate) ]]; then
            echo "$line" | sed -e 's/^[ \t]*//' >> "$OUTPUT_FILE"
        fi
    done < "$i"
    echo -e "\n" >> "$OUTPUT_FILE"
done
if ! git diff --quiet -- "$output_file"; then
    # Add, commit, and push the file to the GitHub repository
    git add "$output_file"
    git config --global user.email "github-actions[bot]@users.noreply.github.com"
    git config --global user.name "github-actions[bot]"
    git commit -m "Added output.md via GitHub Action"
    git push
else
    echo "No changes to commit."
fi
