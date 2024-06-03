#!/bin/bash

function display() {
    echo "Choose your option"
    echo "1. Username search"
    echo "2. Domain search"
    echo "3. Email search"
    echo "4. Exit"
}

while true; do
    display
    read -r choice
    case $choice in
        1)
            echo "Enter username:"
            read -r uname
            bash src/uname.sh "$uname"
            ;;
        2)
            echo "Enter domain name:"
            read -r domain
            bash src/domain.sh "$domain"
            ;;
        3)
            echo "Enter email address:"
            read -r email
            bash src/email.sh "$email"
            ;;
        4)
            exit
            ;;
        *)
            echo "Enter a valid option"
            ;;
    esac
done
