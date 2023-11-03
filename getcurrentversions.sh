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
    # Extract the image value
    image=$(grep -o 'image:\s\+\S\+' "$i" | awk '{print $2}')
    
    # Extract the imageTag value using grep
    imageTag=$(grep 'imageTag:' "$i" | awk -F': ' '{print $2}')
    
    # Check if both image and imageTag are non-empty
    if [ -n "$image" ] && [ -n "$imageTag" ]; then
        # Print the extracted information as a row in the table
        echo "| $image | $imageTag |" >> "$output_file"
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
