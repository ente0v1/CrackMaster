#!/bin/bash

# Wordlist + Rule
# Example:  hashcat -a 0 -m 0 example.hash example.dict example.rule


source windows/functions.sh
define_default_parameters
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

echo -e "${RED}Enter Rules Path (press Enter to use default '$default_rules'):${NC}"
read rule_path_input
rule_path=${rules_path_input:-$default_rules}

echo -e "${MAGENTA}Available Rules in $rules_path:${NC}"
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
status_timer=${status_timer_input:-default_status_timer}

# Print the hashcat command
echo -e "${GREEN}Restore >>${NC} $default_restorepath/$session"
echo -e "${GREEN}Command >>${NC} hashcat --session="$session" -m "$hashmode" hash -a 0 -w 4 --outfile-format=2 -o plaintext.txt "$wordlist" -r "$rule""

# Execute hashcat with rules
if [ "$status_timer" = "y" ]; then
    hashcat --session="$session" --status --status-timer=2 -m "$hashmode" hash -a 0 -w "$workload" --outfile-format=2 -o plaintext.txt "$wordlist_path/$wordlist" -r "$rule"
else
    hashcat --session="$session" -m "$hashmode" hash -a 0 -w "$workload" --outfile-format=2 -o plaintext.txt "$wordlist_path/$wordlist" -r "$rule"
fi

# Save successful settings
save_settings "$session" "$wordlist_path" "$wordlist" "" "$rule"
save_logs

