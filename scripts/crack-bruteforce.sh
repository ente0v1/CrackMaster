#!/bin/bash
# Brute-force
# Example:  hashcat -a 3 -m 0 example.hash ?a?a?a?a?a?a

# Function to handle hashcat execution and check for success
run_hashcat() {
    local session="$1"
    local hashmode="$2"
    local mask="$3"
    local workload="$4"
    local status_timer="$5"

    temp_output=$(mktemp)

    if [ "$status_timer" = "y" ]; then
        hashcat --session="$session" --status --status-timer=2 -m "$hashmode" hash.txt -a 3 -w "$workload" --outfile-format=2 -o plaintext.txt "$mask" | tee $temp_output
    else
        hashcat --session="$session" -m "$hashmode" hash.txt -a 3 -w "$workload" --outfile-format=2 -o plaintext.txt "$mask" | tee $temp_output
    fi

    # Read the content of the temporary file into a variable
    hashcat_output=$(cat "$temp_output")

    # Output the captured output
    echo "$hashcat_output"

    if echo "$hashcat_output" | grep -q "Cracked"; then
        echo -e "${GREEN}Hashcat found the plaintext! Saving logs...${NC}"
        sleep 2
        save_logs
        save_settings "$session" "$wordlist_path" "$wordlist" ""
    else
        echo -e "${RED}Hashcat did not find the plaintext.${NC}"
        sleep 2
    fi
    
    # Remove the temporary file
    rm "$temp_output"
}


source windows/functions.sh
#define_default_parameters
define_my_parameters
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

echo -e "${RED}Enter Masks Path (press Enter to use default '$default_masks'):${NC}"
read mask_path_input
masks_path=${mask_path_input:-$default_masks}

echo -e "${MAGENTA}Available Masks in $masks_path:${NC}"
ls "$masks_path"

echo -e "${MAGENTA}Enter Mask (press Enter to use default '$default_mask'):${NC}"
read mask_input
mask=${mask_input:-$default_mask}

echo -e "${MAGENTA}Use status timer? (y/n)${NC}"
read status_timer_input

# Prompt for min length
echo -e "${MAGENTA}Enter Minimum Length (press Enter to use default '$default_min_length'):${NC}"
read min_length_input
min_length=${min_length_input:-$default_min_length}

# Prompt for max length
echo -e "${MAGENTA}Enter Maximum Length (press Enter to use default '$default_max_length'):${NC}"
read max_length_input
max_length=${max_length_input:-$default_max_length}

# Prompt hash attack mode
echo -e "${MAGENTA}Enter hash attack mode (press Enter to use default '22000'):${NC}"
read hashmode_input
hashmode=${hashmode_input:-$default_hashmode}

# Prompt for workload
echo -e "${MAGENTA}Enter workload (press Enter to use default '$default_workload') [1-4]:${NC}"
read workload_input
workload=${workload_input:-$default_workload}

# Print the hashcat command
echo -e "${GREEN}Restore >>${NC} $default_restorepath/$session"
echo -e "${GREEN}Command >>${NC} hashcat --session=\"$session\" --increment --increment-min=\"$min_length\" --increment-max=\"$max_length\" -m \"$hashmode\" hash.txt -a 3 -w \"$workload\" --outfile-format=2 -o plaintext.txt \"$mask\""

# Execute hashcat with brute-force attack and increment options
run_hashcat "$session" "$hashmode" "$mask" "$workload" "$status_timer"
