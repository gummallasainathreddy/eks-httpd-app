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
    echo "## $i" >> "$output_file"
    
    # Extract image and imageTag values using grep
    image=$(grep -Po 'image:\s+\K[^[:space:]]+' "$i")
    image_tag=$(grep -Po 'imageTag:\s+\K[^[:space:]]+' "$i")

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
