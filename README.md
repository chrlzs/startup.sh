# Welcome Script

This Bash script provides a friendly welcome message along with essential system information, including the local IP address, system details, and recent news headlines.

## Usage

### Prerequisites

- Bash (usually pre-installed on Unix-based systems)
- [`jq`](https://stedolan.github.io/jq/) - A lightweight and flexible command-line JSON processor.

### Getting Started

1. **Obtain a News API Key** from [News API](https://newsapi.org/).

2. **Create `config.cfg` and `script_log.txt` in the Home Directory**:

   Create a configuration file `config.cfg` in your home directory with the following content:

   ```bash
   # config.cfg

   # News API Key
   # Get your API Key here: https://newsapi.org/
   apiKey="[YOUR API KEY HERE]"
   ```

   Create an empty log file `script_log.txt` in your home directory:

   ```bash
   touch ~/script_log.txt
   ```

3. **Run the Script**:

   ```bash
   ./welcome_script.sh
   ```

## Functions

- **display_welcome**: Displays a warm welcome message using figlet if available.
- **display_date_time**: Shows the current date and time.
- **display_ip_address**: Provides your local IP address.
- **display_system_info**: Offers details about the system, including CPU, memory, and disk space.
- **display_news**: Fetches and displays the top 2 recent news headlines.

## Color Codes

- **Red**: System information.
- **Cyan**: Welcome message.
- **Yellow**: Date and time.
- **Light Cyan**: Local IP address.
- **Blue**: Separator lines.

## Running Tests

To verify the functionality of the script, a set of tests has been provided. These tests are written using the [`Bats`](https://github.com/bats-core/bats-core) testing framework.

### Running the Tests

1. Make sure you have `Bats` installed. If not, follow the installation instructions [here](https://github.com/bats-core/bats-core#installing-bats-from-source).
2. Navigate to the directory containing the script and the `tests.bats` file.
3. Run the tests:

   ```bash
   bats tests.bats
   ```

## Troubleshooting

If you encounter any issues:

- Make sure you have the necessary dependencies installed.
- Double-check that your API key is correctly formatted.

## License

This script is provided under the MIT License.
