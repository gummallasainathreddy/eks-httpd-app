#!/bin/bash

# Define the output file name
output_file="output.md"

# Clear the contents of the output file
> "$output_file"

# Create a Markdown table header
echo "| Image | Image Tag |" >> "$output_file"
echo "|-------|-----------|" >> "$output_file"

# Loop through the values.yaml files
for i in $(find . -type f -name "values.yaml"); do
    image=""
    image_tag=""

    while IFS= read -r line; do
        # Remove leading spaces and tabs
        line=$(echo "$line" | sed -e 's/^[ \t]*//')

        # Extract image and imageTag
        if [[ $line =~ image:\ ([^[:space:]]+) ]]; then
            image="${BASH_REMATCH[1]}"
        elif [[ $line =~ imageTag:\ ([^[:space:]]+) ]]; then
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
    git commit -m "Added $output_file via GitHub Action"
    git push
else
    echo "No changes to commit."
fi
