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

# Function to display system information
display_system_info() {
    echo "System Information:"
    uname -a
    echo "CPU Info:"
    lscpu
    echo "Memory Info:"
    free -h
    echo "Disk Space:"
    df -h
}

# Function to fetch and display recent news headlines
display_news() {
    sleep 1
    echo "Recent News Headlines:"
    apiKey=$'[ADD YOUR API KEY]'

    for i in {1..3}; do
        newsData=$(curl -s "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey")
        headlines=$(echo $newsData | /usr/bin/jq -r '.articles[]?.title' | head -n 2)

        if [ $? -ne 0 ]; then
            echo "Error running jq. Check if it's installed and in PATH."
        fi

        if [ -n "$headlines" ]; then
            echo "$headlines"
            return
        else
            echo "Retrying... (Attempt $i)"
            sleep 2  # Wait for a short duration before retrying
        fi
    done

    echo "Unable to fetch news headlines after 3 attempts."
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

    display_ip_address
    printf "${yellow}-------------------------------\n${yellow}"
    display_system_info
    printf "${red}-------------------------------\n${red}"
    display_welcome
    printf "${yellow}-------------------------------\n${yellow}"
    display_date_time
    printf "${cyan}-------------------------------\n${cyan}"
    display_news
    printf "\n${NC}"
}

# Run the main function
main
