#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file 
> $output_file
echo "# Current Versions In Each Environment" >> "$output_file"
for i in $(find . -type f -name "values.yaml"); do
    
    echo "## $i" >> "$output_file"
    directory_name=$(basename "$(dirname "$i")")
    echo "These are the current versions of this environment {**$directory_name**}" >> "$output_file"
    image_lines=$(cat "$i" | grep -E 'image:|imageTag:')
    # Create a Markdown table header
    echo "| Image | ImageTag |" >> "$output_file"
    echo "|-------|----------|" >> "$output_file"

    while read -r line; do
        if [[ $line =~ ^image:\ (.+) ]]; then
            image="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^imageTag:\ (.+) ]]; then
            imageTag="${BASH_REMATCH[1]}"
            # Print the extracted information as a row in the table
            echo "| $image | $imageTag |" >> "$output_file"
        fi
    done <<< "$image_lines" 
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
