#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file
> $output_file
echo "Current Versions In Each Environment"
for i in $(find . -type f -name "values.yaml"); do
    echo "-------------------------" >> $output_file
    echo "$i" >> $output_file
    echo "-------------------------" >> $output_file
    image=""
    image_tag=""
    # Create a Markdown table header
    echo "| Image | Image Tag |" >> "$output_file"
    echo "|-------|-----------|" >> "$output_file"

    # Extract lines containing "image" and "imageTag"
    cat "$i" | grep -E 'image:|imageTag:' | sed -e 's/^[ \t]*//' | while IFS= read -r line; do
        if [[ $line =~ ^image:\ (.+) ]]; then
            image="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^imageTag:\ (.+) ]]; then
            image_tag="${BASH_REMATCH[1]}"
        fi
        done
    # Print the extracted information as a row in the table
    echo "| $image | $image_tag |" >> "$output_file"
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
