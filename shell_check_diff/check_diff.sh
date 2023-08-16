#!/bin/bash

# Ensure we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: not inside a git repository."
    exit 1
fi

# Create the diff directory if it doesn't exist
mkdir -p diff

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Get the list of changed files between the local and remote branches
diff_files=$(git diff --name-only origin/$branch_name)

# If there are any changed files, print a message
if [ -n "$diff_files" ]; then
    echo "There is a diff between local and remote $branch_name"

    # Ask user if they want to continue to generate diff files Y /N
    read -p "Do you want to continue to generate diff files? (Y/N) " -n 1 -r
    echo    # Move to a new line for better readability
    # If user input is Y, continue
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for file in $diff_files; do
            # output the changed files to a diff folder
            git diff origin/$branch_name -- "$file" > "diff/$file.diff"
        done
        echo "Finished generating diff files"
    else
        echo "You chose not to continue"
        exit 1
    fi
else
    echo "There is no diff between local and remote $branch_name"
fi
