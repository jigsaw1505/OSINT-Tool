#!/bin/bash

# Check if username is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME=$1
OUTPUT_FILE="${USERNAME}_info.txt"

# Clear output file if it exists
> $OUTPUT_FILE

# Function to gather information from GitHub
function gather_github_info() {
    echo "Gathering information from GitHub..."
    GITHUB_API="https://api.github.com/users/$USERNAME"
    RESPONSE=$(curl -s $GITHUB_API)

    if echo "$RESPONSE" | jq .message | grep -q "Not Found"; then
        echo "GitHub: User not found"
        echo "GitHub: User not found" >> $OUTPUT_FILE
    else
        echo "GitHub:" >> $OUTPUT_FILE
        echo "$RESPONSE" | jq '. | {login, name, company, blog, location, email, bio, public_repos, followers, following}' >> $OUTPUT_FILE
    fi
}

# Function to gather information from Twitter
function gather_twitter_info() {
    echo "Gathering information from Twitter..."
    TWITTER_API="https://api.twitter.com/2/users/by/username/$USERNAME"
    BEARER_TOKEN="YOUR_TWITTER_BEARER_TOKEN" # Replace with your Twitter API Bearer Token
    RESPONSE=$(curl -s -H "Authorization: Bearer $BEARER_TOKEN" $TWITTER_API)

    if echo "$RESPONSE" | jq .errors | grep -q "Could not find user"; then
        echo "Twitter: User not found"
        echo "Twitter: User not found" >> $OUTPUT_FILE
    else
        echo "Twitter:" >> $OUTPUT_FILE
        echo "$RESPONSE" | jq '.data | {id, name, username, location, description, public_metrics}' >> $OUTPUT_FILE
    fi
}

# Function to gather information from other sources (e.g., Instagram, Reddit)
# Add additional functions here as needed

# Start gathering information
echo "Starting OSINT information gathering for username: $USERNAME"
echo "Output will be saved to $OUTPUT_FILE"

# Gather information from various sources
gather_github_info
gather_twitter_info

# Add additional function calls here

echo "Information gathering completed. Check $OUTPUT_FILE for details."

# End of script
