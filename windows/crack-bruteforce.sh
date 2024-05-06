#!/bin/bash

# Brute-force
# Example:  hashcat -a 3 -m 0 example.hash ?a?a?a?a?a?a


source ./functions.sh
define_default_parameters
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
echo -e "\n${MAGENTA}Enter hash attack mode (press Enter to use default '22000'):${NC}"
read hashmode_input
hashmode=${hashmode:-$default_hashmode}

# Prompt user inputs
echo -e "${MAGENTA}Enter session name (press Enter to use default '$default_session'):${NC}"
read session_input
session=${session_input:-$default_session}

echo -e "${MAGENTA}Enter Mask (press Enter to use default '$default_mask'):${NC}"
read mask_input
mask=${mask_input:-$default_mask}

echo -e "${MAGENTA}Use status timer? (y/n)${NC}"
read status_timer_input

# Prompt for min length
echo -e "${MAGENTA}Enter Minimum Length (press Enter to use default '$default_min_length'):${NC}"
read min_length
min_length=${min_length:-$default_min_length}

# Prompt for max length
echo -e "${MAGENTA}Enter Maximum Length (press Enter to use default '$default_max_length'):${NC}"
read max_length
max_length=${max_length:-$default_max_length}

# Print the hashcat command
echo -e "${GREEN}Restore >>${NC} $default_restorepath/$session"
echo -e "${GREEN}Command >>${NC} hashcat --session="$session" --increment --increment-min="$min_length" --increment-max="$max_length" -m "$hashmode" hash.hc22000 -a 6 -w 4 --outfile-format=2 -o plaintext.txt "$wordlist_path/$wordlist" "$mask""

# Execute hashcat with combined attack (wordlist + mask) and increment options
if [ "$status_timer_input" = "y" ]; then
    hashcat.exe --session="$session" --status --status-timer=2 -m "$hashmode" hash.hc22000 -a 3 -w 4 --outfile-format=2 -o plaintext.txt "$mask"
else
    hashcat.exe --session="$session" -m "$hashmode" hash.hc22000 -a 3 -w 4 --outfile-format=2 -o plaintext.txt "$mask"
fi

# Save successful settings
save_settings "$session" "" "" "$mask" ""
save_logs
