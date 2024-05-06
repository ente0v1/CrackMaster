#!/bin/bash

# Wordlist
# Example:  hashcat -a 0 -m 0 example.hash example.dict


source ../functions.sh
define_windows_parameters
#define_my_parameters
define_colors

# List available sessions
echo -e "${GREEN}Available sessions:${NC}"
restore_files=$(find "$default_restorepath" -name "*.restore" -exec basename {} \; | sed 's/\.restore$//')
if [ -z "$restore_files" ]; then
    echo "No restore files found..."
else
    echo "$restore_files"
fi

# Restore session if requested
echo -e "\n${RED}Restore? (Enter restore file name or leave empty):${NC}"
read restore_file_input
restore_session "$restore_file_input"

# Prompt hash attack mode
echo -e "${MAGENTA}Enter hash attack mode (press Enter to use default '22000'):${NC}"
read hashmode_input
hashmode=${hashmode_input:-$default_hashmode}

# Prompt user inputs
echo -e "${MAGENTA}Enter session name (press Enter to use default '$default_session'):${NC}"
read session_input
session=${session_input:-$default_session}

echo -e "${RED}Enter Wordlists Path (press Enter to use default '$default_wordlists'):${NC}"
read wordlist_path_input
wordlist_path=${wordlist_path_input:-$default_wordlists}

echo -e "${MAGENTA}Available Wordlists in $wordlist_path:${NC}"
ls "$wordlist_path"

echo -e "${MAGENTA}Enter Wordlist (press Enter to use default '$default_wordlist'):${NC}"
read wordlist_input
wordlist=${wordlist_input:-$default_wordlist}

# Prompt for hashcat path
echo -e "${RED}Enter Hashcat Path:${NC}"
read hashcat_path

# Print the hashcat command
echo -e "${GREEN}Restore >>${NC} $default_restorepath/$session"
echo -e "${GREEN}Command >>${NC} hashcat --session="$session" -m "$hashmode" hash.hc22000 -a 0 -w 4 --outfile-format=2 -o plaintext.txt "$wordlist_path/$wordlist""

# Execute hashcat with the specified wordlist
"$hashcat_path/hashcat.exe" --session="$session" -m "$hashmode" hash.hc22000 -a 0 -w 4 --outfile-format=2 -o plaintext.txt "$wordlist_path/$wordlist"

# Save successful settings
save_settings "$session" "$wordlist_path" "$wordlist" ""
save_logs


