#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v $1 > /dev/null 2>&1
}

# Function to display a welcome message
display_welcome() {
    if command_exists figlet; then
        figlet -f mini "W e l c o m e   $USER" | while IFS= read -r line; do
            echo -e "\033[2K\033[1G$line"
            sleep 0.1  # Adjust the sleep duration to control the animation speed
        done
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
    apiKey='[YOUR API KEY HERE]'

    if [ -z "$apiKey" ] || [ "$apiKey" = '[YOUR API KEY HERE]' ]; then
        echo "No valid API key provided. Unable to fetch news headlines."
        return
    fi

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
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    blue=$(tput setaf 4)
    magenta=$(tput setaf 5)
    cyan=$(tput setaf 6)
    white=$(tput setaf 7)
    reset=$(tput sgr0)

    display_ip_address
    printf "${yellow}-------------------------------\n${reset}"
    display_system_info
    printf "${red}-------------------------------\n${reset}"
    display_welcome
    printf "${yellow}-------------------------------\n${reset}"
    display_date_time
    printf "${cyan}-------------------------------\n${reset}"
    display_news
    printf "\n${white}"
}

# Run the main function
main
