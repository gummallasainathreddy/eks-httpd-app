#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file
> "$output_file"

# Create the table header
echo "| Image | Image Tag |" >> "$output_file"
echo "|-------|-----------|" >> "$output_file"

# Extract image and imageTag values from the values.yaml file
image=$(grep -o 'image:\s\+\S\+' values.yaml | awk '{print $2}')
imageTag=$(grep -o 'imageTag:\s\+\S\+' values.yaml | awk '{print $2}')

# Check if both image and imageTag are non-empty
if [ -n "$image" ] && [ -n "$imageTag" ]; then
    # Print the extracted information as a row in the table
    echo "| $image | $imageTag |" >> "$output_file"
fi
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
