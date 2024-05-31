#!/bin/bash
while true do
# Function to display usage information
function usage() {
    echo "Usage: $0 <domain>"
    exit 1
}

# Check if domain is provided
if [ -z "$1" ]; then
    usage
fi

DOMAIN=$1
OUTPUT_FILE="osint_$DOMAIN.txt"

# Function to gather whois information
function gather_whois() {
    echo "Gathering WHOIS information..."
    whois $DOMAIN > $OUTPUT_FILE
    echo "WHOIS information saved to $OUTPUT_FILE"
}

# Function to gather DNS information
function gather_dns() {
    echo "Gathering DNS information..."
    {
        echo -e "\n\n==== DNS Information ===="
        echo "NS Records:"
        dig ns $DOMAIN +short
        echo -e "\nMX Records:"
        dig mx $DOMAIN +short
        echo -e "\nA Record:"
        dig a $DOMAIN +short
        echo -e "\nAAAA Record:"
        dig aaaa $DOMAIN +short
        echo -e "\nTXT Records:"
        dig txt $DOMAIN +short
    } >> $OUTPUT_FILE
    echo "DNS information saved to $OUTPUT_FILE"
}

# Function to gather subdomain information
function gather_subdomains() {
    echo "Gathering Subdomain information..."
    {
        echo -e "\n\n==== Subdomain Information ===="
        subfinder -d $DOMAIN
    } >> $OUTPUT_FILE
    echo "Subdomain information saved to $OUTPUT_FILE"
}

# Function to gather HTTP headers
function gather_http_headers() {
    echo "Gathering HTTP headers..."
    {
        echo -e "\n\n==== HTTP Headers ===="
        curl -I http://$DOMAIN
    } >> $OUTPUT_FILE
    echo "HTTP headers saved to $OUTPUT_FILE"
}

# Function to gather web technologies
function gather_technologies() {
    echo "Gathering web technologies..."
    {
        echo -e "\n\n==== Web Technologies ===="
        whatweb $DOMAIN
    } >> $OUTPUT_FILE
    echo "Web technologies information saved to $OUTPUT_FILE"
}

# Main function to gather all information
function gather_all_info() {
    echo "Starting OSINT information gathering for domain: $DOMAIN"
    gather_whois
    gather_dns
    gather_subdomains
    gather_http_headers
    gather_technologies
    echo "OSINT information gathering completed. Check $OUTPUT_FILE for details."
}

# Call the main function
gather_all_info
