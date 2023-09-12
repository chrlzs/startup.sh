#!/usr/bin/env bats

# Load the script to be tested
load ./startup.sh

@test "Check if figlet is installed" {
    run command_exists figlet
    [ "$status" -eq 0 ]
}

@test "Display welcome message" {
    run display_welcome
    [ "$status" -eq 0 ]
}

@test "Display date and time" {
    run display_date_time
    [ "$status" -eq 0 ]
}

@test "Display local IP address" {
    run display_ip_address
    [ "$status" -eq 0 ]
}

# Mock data for testing
mockNewsData='{
  "articles": [
    {"title": "Sample News 1"},
    {"title": "Sample News 2"},
    {"title": "Sample News 3"}
  ]
}'

@test "Display recent news headlines" {
    run display_news "$mockNewsData"
    [ "$status" -eq 0 ]
    [ -n "$output" ]
}

@test "Display system information" {
    run display_system_info
    [ "$status" -eq 0 ]
}

