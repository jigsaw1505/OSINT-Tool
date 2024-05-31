#!/bin/bash

# Check if email address is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <email_address>"
    exit 1
fi

EMAIL="$1"

# Function to perform DNS MX record lookup
dns_mx_lookup() {
    echo "Performing DNS MX lookup for domain..."
    DOMAIN=$(echo $EMAIL | awk -F '@' '{print $2}')
    echo "Domain: $DOMAIN"
    dig MX $DOMAIN +short
}

# Function to check if email is in HaveIBeenPwned database
haveibeenpwned_check() {
    echo "Checking HaveIBeenPwned for breaches..."
    RESPONSE=$(curl -s https://haveibeenpwned.com/api/v2/breachedaccount/$EMAIL)
    if [[ $RESPONSE == "[]" ]]; then
        echo "No breaches found for $EMAIL"
    else
        echo "Breaches found for $EMAIL:"
        echo $RESPONSE | jq '.'
    fi
}

# Function to check email validation and existence using Hunter.io API (you need an API key)
hunter_check() {
    echo "Checking email validation with Hunter.io..."
    API_KEY="YOUR_HUNTER_IO_API_KEY"
    RESPONSE=$(curl -s "https://api.hunter.io/v2/email-verifier?email=$EMAIL&api_key=$API_KEY")
    echo $RESPONSE | jq '.data'
}

# Function to gather public data from Pipl (you need an API key)
pipl_check() {
    echo "Gathering data from Pipl..."
    API_KEY="YOUR_PIPL_API_KEY"
    RESPONSE=$(curl -s "https://api.pipl.com/search/?email=$EMAIL&key=$API_KEY")
    echo $RESPONSE | jq '.'
}

# Function to check email reputation using EmailRep.io
emailrep_check() {
    echo "Checking email reputation with EmailRep.io..."
    RESPONSE=$(curl -s "https://emailrep.io/$EMAIL")
    echo $RESPONSE | jq '.'
}

# Main execution
echo "Gathering information for email: $EMAIL"
dns_mx_lookup
haveibeenpwned_check
hunter_check
pipl_check
emailrep_check

echo "Information gathering completed."
