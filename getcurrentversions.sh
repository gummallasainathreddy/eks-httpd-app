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
    image=$(grep -o 'image:\s\+\S\+' "$i" | awk '{print $2}')
    imageTag=$(grep -o 'imageTag:\s\+\S\+' "$i" | awk '{print $2}')
    # Create a Markdown table header
    echo "| Image | ImageTag |" >> "$output_file"
    echo "|-------|----------|" >> "$output_file"

    if [ -n "$image" ] && [ -n "$imageTag" ]; then
       # Print the extracted information as a row in the table
       echo "| $image |" >> "$output_file"
       echo "| $imageTag |" >> "$output_file"
    fi
        
    # Print the extracted information as a row in the table
    #echo "| $image | $imageTag |" >> "$output_file" 
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
