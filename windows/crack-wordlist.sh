#!/bin/bash
# Wordlist
# Example:  hashcat -a 0 -m 0 example.hash example.dict

# Function to handle hashcat execution and check for success
run_hashcat() {
    local session="$1"
    local hashmode="$2"
    local wordlist_path="$3"
    local wordlist="$4"
    local workload="$5"
    local status_timer="$6"
    local hashcat_path="$7"

    if [ "$status_timer" = "y" ]; then
        hashcat_output=$("$hashcat_path/hashcat.exe" --session="$session" --status --status-timer=2 -m "$hashmode" hash.txt -a 0 -w "$workload" --outfile-format=2 -o plaintext.txt "$wordlist_path/$wordlist")
    else
        hashcat_output=$("$hashcat_path/hashcat.exe" --session="$session" -m "$hashmode" hash.txt -a 0 -w "$workload" --outfile-format=2 -o plaintext.txt "$wordlist_path/$wordlist")
    fi

    if echo "$hashcat_output" | grep -q "Cracked"; then
        echo -e "${GREEN}Hashcat found the plaintext! Saving logs...${NC}"
        sleep 2
        save_logs
        save_settings "$session" "$wordlist_path" "$wordlist" ""
    else
        echo -e "${RED}Hashcat did not find the plaintext.${NC}"
        sleep 2
    fi
}


source windows/functions.sh
define_windows_parameters
#define_my_parameters
define_colors

# Restore session if requested
list_sessions
echo -e "\n${RED}Restore? (Enter restore file name or leave empty):${NC}"
read restore_file_input
restore_session "$restore_file_input"

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
echo -e "${RED}Enter Hashcat Path (press Enter to use default '$default_hashcat'):${NC}"
read hashcat_path_input
hashcat_path=${hashcat_path_input:-$default_hashcat}

# Prompt hash attack mode
echo -e "${MAGENTA}Enter hash attack mode (press Enter to use default '22000'):${NC}"
read hashmode_input
hashmode=${hashmode_input:-$default_hashmode}

# Prompt for workload
echo -e "${MAGENTA}Enter workload (press Enter to use default '$default_workload') [1-4]:${NC}"
read workload_input
workload=${workload_input:-$default_workload}

echo -e "${MAGENTA}Use status timer? (press Enter to use default '$default_status_timer') [y/n]:${NC}"
read status_timer_input
status_timer=${status_timer_input:-default_status_timer}

# Print the hashcat command
echo -e "${GREEN}Restore >>${NC} $default_restorepath/$session"
echo -e "${GREEN}Command >>${NC} \"$hashcat_path/hashcat.exe\" --session=\"$session\" -m \"$hashmode\" hash.txt -a 0 -w \"$workload\" --outfile-format=2 -o plaintext.txt \"$wordlist_path/$wordlist\""

# Execute hashcat with the specified wordlist
run_hashcat "$session" "$hashmode" "$wordlist_path" "$wordlist" "$workload" "$status_timer" "$hashcat_path"