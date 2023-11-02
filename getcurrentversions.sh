#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file
> "$output_file"

# Create the table header
echo "# Current Versions In Each Environment" >> "$output_file"
echo "| Environment | Image | Image Tag |" >> "$output_file"
echo "|-------------|-------|-----------|" >> "$output_file"

# Loop through the values.yaml files
for i in $(find . -type f -name "values.yaml"); do
    # Extract the environment name from the directory
    environment=$(dirname "$i" | sed 's/.\///')

    image=""
    image_tag=""

    # Extract lines containing "image" and "imageTag" from the values.yaml file
    while IFS= read -r line; do
        if [[ $line =~ ^image:\ (.+) ]]; then
            image="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^imageTag:\ (.+) ]]; then
            image_tag="${BASH_REMATCH[1]}"
        fi
    done < "$i"

    # Check if both image and imageTag are non-empty
    if [ -n "$image" ] && [ -n "$image_tag" ]; then
        # Print the extracted information as a row in the table
        echo "| $environment | $image | $image_tag |" >> "$output_file"
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
