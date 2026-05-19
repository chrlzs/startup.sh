#!/bin/bash

CONFIG_FILE="$HOME/config.cfg"
LOG_FILE="$HOME/script_log.txt"

# Load configuration file
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
else
    echo "Error: Configuration file not found."
    exit 1
fi

# Function to log messages
log_message() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" > /dev/null 2>&1
}

# Function to display a welcome message
display_welcome() {
    if command_exists figlet; then
        figlet -f mini "W e l c o m e   $USER" | while IFS= read -r line; do
            echo -e "\033[2K\033[1G$line"
            sleep 0.1
        done
    else
        echo "Welcome $USER"
    fi
}

# Function to get and display the current date and time
display_date_time() {
    currentDate=$(date +"%A, %m %d %Y %I:%M:%S %p")
    echo "$currentDate"
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

# Function to handle errors
handle_error() {
    local error_message="$1"
    echo "Error: $error_message"
    log_message "Error: $error_message"
    exit 1
}

# Function to fetch and display recent news headlines
display_news() {
    local retries=3

    # Define variables for API URL and country code
    local apiUrl="https://newsapi.org/v2/top-headlines"
    local countryCode="us"

    echo "Recent News Headlines:"

    if [ -z "$apiKey" ] || [ "$apiKey" = '[API KEY HERE]' ]; then
        handle_error "No valid API key provided. Unable to fetch news headlines."
        return
    fi

    # Check network connectivity
    if ! ping -c 1 google.com > /dev/null 2>&1; then
        handle_error "No internet connection. Unable to fetch news headlines."
        return
    fi
    
    for i in $(seq 1 $retries); do
        local newsData sanitizedNewsData error message headlines

        newsData=$(curl -fsS --max-time 15 "$apiUrl?country=$countryCode&apiKey=$apiKey" 2>> "$LOG_FILE")
        
        # Check if curl was successful and if we got valid data
        if [ $? -ne 0 ] || [ -z "$newsData" ]; then
            echo "Error fetching data from NewsAPI"
            continue
        fi

        if ! printf '%s' "$newsData" | jq -e . > /dev/null 2>&1; then
            sanitizedNewsData=$(printf '%s' "$newsData" | perl -0777 -pe '
                my $out = "";
                my $in_string = 0;
                my $escaped = 0;

                for my $char (split //) {
                    my $ord = ord($char);

                    if ($in_string && $ord < 32) {
                        $out .= sprintf("\\u%04x", $ord);
                        $escaped = 0;
                        next;
                    }

                    if (!$in_string && $ord < 32 && $char !~ /[\t\r\n]/) {
                        next;
                    }

                    $out .= $char;

                    if ($escaped) {
                        $escaped = 0;
                    } elsif ($char eq "\\") {
                        $escaped = 1;
                    } elsif ($char eq "\"") {
                        $in_string = !$in_string;
                    }
                }

                $_ = $out;
            ')

            if printf '%s' "$sanitizedNewsData" | jq -e . > /dev/null 2>&1; then
                newsData="$sanitizedNewsData"
                log_message "Sanitized raw control characters in NewsAPI response."
            else
                echo "Invalid JSON received from NewsAPI"
                log_message "Invalid NewsAPI JSON response: $(printf '%s' "$newsData" | head -c 500)"
                echo "Retrying... (Attempt $i)"
                sleep 2
                continue
            fi
        fi
        
        # Debug: Check the response content
        if [ "$i" -eq 1 ]; then
            echo "API Response:" >> "$LOG_FILE"
            echo "$newsData" | head -c 500 >> "$LOG_FILE"
            echo "..." >> "$LOG_FILE"
        fi

        # Check if response contains error message
        error=$(printf '%s' "$newsData" | jq -r '.status // empty')
        if [ "$error" = "error" ]; then
            message=$(printf '%s' "$newsData" | jq -r '.message // "Unknown NewsAPI error"')
            echo "API Error: $message"
            continue
        fi

        headlines=$(printf '%s' "$newsData" | jq -r '.articles[]?.title' 2>/dev/null | head -n 2)

        if [ $? -eq 0 ] && [ -n "$headlines" ]; then
            echo "$headlines"
            return
        else
            echo "Retrying... (Attempt $i)"
            sleep 2
        fi
    done

    echo "Unable to fetch news headlines after $retries attempts."
    log_message "Failed to fetch news headlines after $retries attempts."
    handle_error "Unable to fetch news headlines."
}

# Function for a basic loading spinner
loading_spinner() {
    local pid=$1
    local spin='-\|/'
    
    while [ -d "/proc/$pid" ]; do
        local temp=${spin#?}
        printf " [%c] " "$spin"
        local spin=$temp${spin%"$temp"}
        sleep 0.1
        printf "\b\b\b\b\b\b"
    done
    
    printf "    \b\b\b\b"
}

# Main function
main() {
    log_message "Script started."
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
    log_message "Script completed."
}

# Run the main function
main
