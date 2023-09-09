#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v $1 > /dev/null 2>&1
}

# Function to display a welcome message
display_welcome() {
    if command_exists figlet; then
        figlet -f mini welcome $USER
    else
        echo "Welcome $USER"
    fi
}

# Function to get and display the current date and time
display_date_time() {
    currentDate=$(date +"%A, %m %d %Y %I:%M:%S %p")
    echo $currentDate
}

# Function to display the local IP address
display_ip_address() {
    echo -n "Local IP address: "
    hostname -I
}

# Function to fetch and display weather information
display_weather() {
    curl wttr.in?format=3 --retry 4
}

# Main function
main() {
    # Color definitions
    red='\033[0;31m'
    cyan='\033[0;36m'
    lightCyan='\033[1;36m'
    blue='\033[0;34m'
    yellow="\033[0;33m"
    NC='\033[0m' # No Color

    printf "Welcome ${cyan}$USER${yellow}\n"
    display_date_time
    printf "${blue}-------------------------------\n${lightCyan}"
    display_ip_address
    printf "\n${NC}"
    display_weather
    printf "\n"
}

# Run the main function
main
