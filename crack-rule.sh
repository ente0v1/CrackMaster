#!/bin/bash
# Wordlist + Rule
# Example: hashcat -a 0 -m 0 example.hash example.dict example.rule

# Function to handle hashcat execution and check for success
run_hashcat() {
    local session="$1"
    local hashmode="$2"
    local wordlist_path="$3"
    local wordlist="$4"
    local rule_path="$5"
    local rule="$6"
    local workload="$7"
    local status_timer="$8"

    temp_output=$(mktemp)

    if [ "$status_timer" = "y" ]; then
        hashcat --session="$session" --status --status-timer=2 -m "$hashmode" hash.txt -a 0 -w "$workload" --outfile-format=2 -o plaintext.txt "$wordlist_path/$wordlist" -r "$rule_path/$rule") | tee $temp_output
    else
        hashcat --session="$session" -m "$hashmode" hash.txt -a 0 -w "$workload" --outfile-format=2 -o plaintext.txt "$wordlist_path/$wordlist" -r "$rule_path/$rule") | tee $temp_output
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

echo -e "${RED}Enter Wordlists Path (press Enter to use default '$default_wordlists'):${NC}"
read wordlist_path_input
wordlist_path=${wordlist_path_input:-$default_wordlists}

echo -e "${MAGENTA}Available Wordlists in $wordlist_path:${NC}"
ls "$wordlist_path"

echo -e "${MAGENTA}Enter Wordlist (press Enter to use default '$default_wordlist'):${NC}"
read wordlist_input
wordlist=${wordlist_input:-$default_wordlist}

echo -e "${RED}Enter Rules Path (press Enter to use default '$default_rules'):${NC}"
read rule_path_input
rule_path=${rule_path_input:-$default_rules}

echo -e "${MAGENTA}Available Rules in $rule_path:${NC}"
ls "$rule_path"

echo -e "${MAGENTA}Enter Rule (press Enter to use default '$default_rule'):${NC}"
read rule_input
rule=${rule_input:-$default_rule}

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
status_timer=${status_timer_input:-$default_status_timer}

# Print the hashcat command
echo -e "${GREEN}Restore >>${NC} $default_restorepath/$session"
echo -e "${GREEN}Command >>${NC} hashcat --session=\"$session\" -m \"$hashmode\" hash.txt -a 0 -w \"$workload\" --outfile-format=2 -o plaintext.txt \"$wordlist_path/$wordlist\" -r \"$rule_path/$rule\""

# Execute hashcat with rules
run_hashcat "$session" "$hashmode" "$wordlist_path" "$wordlist" "$rule_path" "$rule" "$workload" "$status_timer"
