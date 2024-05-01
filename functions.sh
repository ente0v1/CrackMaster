#!/bin/bash
default_scripts="/home/$USER/Crack_Master"

# Function to define colors
define_colors() {
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    MAGENTA='\033[0;35m'
    CYAN='\033[0;36m'
    NC='\033[0m' # No Color
}

# Function to define default parameters
define_default_parameters() {
    default_restorepath="/root/.local/share/hashcat/sessions"
    default_session=$(date +"%Y-%m-%d")
    default_wordlists="/usr/share/wordlists"
    default_masks="/usr/share/hashcat/masks"
    default_rules="/usr/share/hashcat/rules"
    default_wordlist="rockyou.txt"
    default_mask="?d?d?d?d"
    default_rule="T0XlCv2.rule"
    default_min_length="4"
    default_max_length="16"
}

# Function to clear the screen
clear_screen() {
    clear
}

# Function to generate a random color
random_color() {
    local colors=("\033[0;31m" "\033[0;32m" "\033[1;33m")
    local random_index=$((RANDOM % ${#colors[@]}))
    echo -e "${colors[$random_index]}"
}

show_title() {
    local title_color=$(random_color)
    echo -e "${title_color}"
    cat <<EOF
    Your Title Here
EOF
    echo -e "${NC}"  # Reset color
}

# Function to display the menu
show_menu() {
    local title_color=$(random_color)  # Color for the title
    local option_color="${title_color}" # Use the same color for all options
    echo -e "${title_color}"
    cat <<EOF



		       ▄▀▄▄▄▄   ▄▀▀▄▀▀▀▄  ▄▀▀█▄   ▄▀▄▄▄▄   ▄▀▀▄ █            
		      █ █    ▌ █   █   █ ▐ ▄▀ ▀▄ █ █    ▌ █  █ ▄▀            
		      ▐ █      ▐  █▀▀█▀    █▄▄▄█ ▐ █      ▐  █▀▄             
		        █       ▄▀    █   ▄▀   █   █        █   █            
		       ▄▀▄▄▄▄▀ █     █   █   ▄▀   ▄▀▄▄▄▄▀ ▄▀   █             
		      █     ▐  ▐     ▐   ▐   ▐   █     ▐  █    ▐             
		      ▐                          ▐        ▐                  
		 ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▀▀▄  ▄▀▀▀█▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▄▀▀▀▄
		█  █ ▀  █ ▐ ▄▀ ▀▄ █ █   ▐ █    █  ▐ ▐  ▄▀   ▐ █   █   █
		▐  █    █   █▄▄▄█    ▀▄   ▐   █       █▄▄▄▄▄  ▐  █▀▀█▀ 
		  █    █   ▄▀   █ ▀▄   █     █        █    ▌   ▄▀    █ 
		▄▀   ▄▀   █   ▄▀   █▀▀▀    ▄▀        ▄▀▄▄▄▄   █     █  
		█    █    ▐   ▐    ▐      █          █    ▐   ▐     ▐  
		▐    ▐                    ▐          ▐                 



EOF

    echo -e "${option_color}Menu Options:${NC}"
    echo -e "${option_color}1.${NC} Crack with wordlist only          						  ${CYAN}[EASY]"
    echo -e "${option_color}2.${NC} Crack with rules (Wordlist + Rules)    					  ${GREEN}[MEDIUM]"
    echo -e "${option_color}3.${NC} Crack with brute-force            						  ${YELLOW}[HARD]"
    echo -e "${option_color}4.${NC} Crack with combo (Hybrid Wordlist + Mask)  					  ${RED}[ADVANCED]"
    echo -e "${option_color}Q.${NC} Quit"
    echo "--------------------------------"
    echo -ne "${option_color}Enter option (1-4, or Q to quit): ${NC}"
}


animate_text() {
    local text="$1"
    local delay="$2"

    for (( i=0; i<${#text}; i++ )); do
        clear
        printf "%s" "${text:0:$i}"
        sleep "$delay"
    done
}

# Function to handle the user's selected option
handle_option() {
    local option="$1"

    case "$option" in
        1)
            echo -ne "Executing crack-wordlist script: "
            animate_text "..." 0.1  # Animating ellipsis to indicate processing
            echo -e "${YELLOW}Done!${NC}"
            "$default_scripts/crack-wordlist"
            ;;
        2)
            echo -ne "Executing crack-rule script: "
            animate_text "..." 0.1
            echo -e "${YELLOW}Done!${NC}"
            "$default_scripts/crack-rule"
            ;;
        3)
            echo -ne "Executing crack-bruteforce script: "
            animate_text "..." 0.1
            echo -e "${YELLOW}Done!${NC}"
            "$default_scripts/crack-bruteforce"
            ;;
        4)
            echo -ne "Executing crack-combo script: "
            animate_text "..." 0.1
            echo -e "${YELLOW}Done!${NC}"
            "$default_scripts/crack-combo"
            ;;
        [Qq])
            echo -ne "Exiting: "
            animate_text "..." 0.1
            echo -e "${YELLOW}Done!${NC}"
            echo -e "${YELLOW}Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            ;;
    esac
}

# Function to save successful settings
save_settings() {
    local session="$1"
    local path_wordlists="$2"
    local default_wordlist="$3"
    local mask="$4"
    local plaintext_file="plaintext.txt"
    
    status+="\nSession: $session"
    status+="\nWordlist Path: $path_wordlists/$default_wordlist"
    status+="\nMask: $mask"
    status+="\nPlaintext:\n$(cat $plaintext_file)"
    
    echo -e "$status" > status.txt
}

# Function to handle session restoration
restore_session() {
    local restore_file_input="$1"
    if [ -n "$restore_file_input" ]; then
        local restore_file="$default_restorepath/$restore_file_input.restore"
        if [ ! -f "$restore_file" ]; then
            echo "Error: Restore file '$restore_file' not found."
            exit 1
        else
            local session=$(basename "$restore_file" .restore)
            echo -e "${GREEN}Restore >>${NC} $default_restorepath/$session"
            echo -e "${GREEN}Command >>${NC} hashcat --session="$session" -m 22000 hash.hc22000 -a 0 -w 4 --outfile-format=2 -o plaintext.txt "$default_wordlists/$default_wordlist""
            hashcat --session "$session" --restore
            exit 0
        fi
    fi
}


