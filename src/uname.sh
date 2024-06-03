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
function gather_linkedin_info() {
    echo "Gathering information from LinkedIn..."
    LINKEDIN_API="https://api.linkedin.com/v2/me"
    ACCESS_TOKEN="YOUR_LINKEDIN_ACCESS_TOKEN" # Replace with your LinkedIn Access Token
    RESPONSE=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" $LINKEDIN_API)

    if echo "$RESPONSE" | jq .serviceErrorCode | grep -q "404"; then
        echo "LinkedIn: User not found"
        echo "LinkedIn: User not found" >> $OUTPUT_FILE
    else
        echo "LinkedIn:" >> $OUTPUT_FILE
        echo "$RESPONSE" | jq '. | {id, firstName, lastName, headline, location}' >> $OUTPUT_FILE
    fi
}

# Function to gather information from Instagram
function gather_instagram_info() {
    echo "Gathering information from Instagram..."
    INSTAGRAM_API="https://www.instagram.com/$USERNAME/?__a=1"
    RESPONSE=$(curl -s $INSTAGRAM_API)

    if echo "$RESPONSE" | grep -q "Page Not Found"; then
        echo "Instagram: User not found"
        echo "Instagram: User not found" >> $OUTPUT_FILE
    else
        echo "Instagram:" >> $OUTPUT_FILE
        echo "$RESPONSE" | jq '.graphql.user | {id, username, full_name, biography, edge_followed_by, edge_follow}' >> $OUTPUT_FILE
    fi
}

# Function to gather information from Facebook (Note: Facebook Graph API requires specific permissions)
function gather_facebook_info() {
    echo "Gathering information from Facebook..."
    FACEBOOK_API="https://graph.facebook.com/$USERNAME"
    ACCESS_TOKEN="YOUR_FACEBOOK_ACCESS_TOKEN" # Replace with your Facebook Access Token
    RESPONSE=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" $FACEBOOK_API)

    if echo "$RESPONSE" | jq .error | grep -q "Error"; then
        echo "Facebook: User not found"
        echo "Facebook: User not found" >> $OUTPUT_FILE
    else
        echo "Facebook:" >> $OUTPUT_FILE
        echo "$RESPONSE" | jq '. | {id, name, username, email, location}' >> $OUTPUT_FILE
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
gather_linkedin_info
gather_instagram_info
gather_facebook_info

# Add additional function calls here

echo "Information gathering completed. Check $OUTPUT_FILE for details."

# End of script
