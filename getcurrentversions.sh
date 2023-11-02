#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file 
> $output_file
echo "# Current Versions In Each Environment" >> $output_file
for i in $(find . -type f -name "values.yaml"); do
    #echo "-------------------------" >> $output_file
    echo "## $i" >> $output_file
    #echo "-------------------------" >> $output_file
    image="sai"
    image_tag="1.2.0"
    # Create a Markdown table header
    echo "| Image | Image Tag |" >> "$output_file"
    echo "|-------|-----------|" >> "$output_file"

    # Extract lines containing "image" and "imageTag"
    cat "$i" | grep -E 'image:|imageTag:' | sed -e 's/^[ \t]*//' | tr ' \t' '\n' | while IFS= read -r line; do
        if [[ $line =~ ^image:\ (.+) ]]; then
            image="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^imageTag:\ (.+) ]]; then
            image_tag="${BASH_REMATCH[1]}"
        fi
        done < "$i"
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
