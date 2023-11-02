#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file
> "$output_file"

for i in $(find -name values.yaml); do
    #echo "------------------------------------" >> "$output_file"
    echo "$i" >> "$output_file"
    #echo "------------------------------------" >> "$output_file"
    cat "$i" | grep 'image\|imageTag\|#renovate' | sed -e 's/^[ \t]*//' >> "$output_file"
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
