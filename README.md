
# Welcome Script

This Bash script provides a welcome message along with system information, including the local IP address, system details, and recent news headlines.

## Usage

1. Make sure you have Bash and the required dependencies (jq) installed on your system.

2. Obtain a News API key from [News API](https://newsapi.org/).

3. Insert your News API key into the script.

```bash
 apiKey=$'[YOUR API KEY HERE]'
```

4. Run the script:

```bash
./welcome_script.sh
```

## Functions

- `display_welcome`: Displays a welcome message, using `figlet` if available.
- `display_date_time`: Shows the current date and time.
- `display_ip_address`: Displays the local IP address.
- `display_system_info`: Provides information about the system, including CPU, memory, and disk space.
- `display_news`: Fetches and displays the top 2 recent news headlines.

## Color Codes

- Red: System information
- Cyan: Welcome message
- Yellow: Date and time
- Light Cyan: Local IP address
- Blue: Separator lines

## Troubleshooting

If you encounter any issues, make sure you have the necessary dependencies installed and that your API key is correctly formatted.

## License

This script is provided under the [MIT License](LICENSE).
