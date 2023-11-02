#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file
> "$output_file"

# Create the table header
echo "| Image | Image Tag |" >> "$output_file"
echo "|-------|-----------|" >> "$output_file"

# Loop through the values.yaml files
for i in $(find . -type f -name "values.yaml"); do
    image=$(grep -o 'image:\s\+\S\+' "$i" | awk '{print $2}')
    image_tag=$(grep -o 'imageTag:\s\+\S\+' "$i" | awk '{print $2}')
    
    if [ -n "$image" ] && [ -n "$image_tag" ]; then
        echo "## $i" >> "$output_file"
        echo "| $image | $image_tag |" >> "$output_file"
    fi
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
