#!/bin/bash

default_scripts="/home/enteo/Crack_Master"
default_windows_scripts="/c/Users/alexa/source/repos/ente0v1/Crack_Master/windows"

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
    default_os="Linux"
    default_restorepath="$HOME/.local/share/hashcat/sessions"
    default_session=$(date +"%Y-%m-%d")
    default_wordlists="/usr/share/wordlists"
    default_masks="$default_scripts/masks"
    default_rules="$default_scripts/rules"
    default_wordlist="rockyou.txt"
    default_mask="?d?d?d?d"
    default_rule="T0XlCv2.rule"
    default_min_length="4"
    default_max_length="16"
    default_hashmode="22000"
}

define_windows_parameters() {
    default_os="Windows"
    default_restorepath="$HOME/hashcat/sessions"
    default_session="fsociety"
    default_wordlists="/c/Users/alexa/wordlists"
    default_masks="/c/Users/alexa/source/repos/ente0v1/Crack_Master/masks"
    default_rules="/c/Users/alexa/source/repos/ente0v1/Crack_Master/rules"
    default_wordlist="rockyou.txt"
    default_mask="?d?d?d?d"
    default_rule="T0XlCv2.rule"
    default_min_length="4"
    default_max_length="16"
    default_hashmode="22000"
}

# Function to define customized parameters
define_my_parameters() {
    default_os=
    default_windows_scripts=
    default_restorepath=
    default_session=
    default_wordlists=
    default_masks=
    default_rules=
    default_wordlist=
    default_mask=
    default_rule=
    default_min_length=
    default_max_length=
    default_hashmode=
}

# Function to list available sessions
list_sessions () {
    echo -e "${GREEN}Available sessions:${NC}"
    restore_files=$(find "$default_restorepath" -name "*.restore" -exec basename {} \; | sed 's/\.restore$//')
    if [ -z "$restore_files" ]; then
        echo "No restore files found..."
    else
        echo "$restore_files"
    fi
}

# Function to clear the screen
clear_screen() {
    clear
}

# Function to generate a random color
random_color() {
    local colors=("$RED" "$MAGENTA" "$CYAN" "$BLUE" "$GREEN" "$YELLOW")
    local random_index=$((RANDOM % ${#colors[@]}))
    echo -e "${colors[$random_index]}"
}

# Function to display the menu
show_title() {
    option_color="${color}" # Use the same color for all options
    echo -e "${color}"
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
}

show_windows_menu() {
    echo -e "${option_color}Menu Options for Windows:${NC}"
    echo -e "${option_color}1.${NC} Crack with wordlist only          						  ${CYAN}[EASY]"
    echo -e "${option_color}2.${NC} Crack with rules (Wordlist + Rules)    					  ${GREEN}[MEDIUM]"
    echo -e "${option_color}3.${NC} Crack with brute-force            						  ${YELLOW}[HARD]"
    echo -e "${option_color}4.${NC} Crack with combo (Hybrid Wordlist + Mask)  					  ${RED}[ADVANCED]"
    echo -ne "${option_color}\nPress Enter to switch to Linux.${NC}\n"
    echo "--------------------------------"
    echo -ne "${option_color}Enter option (1-4, or Q to quit): ${NC}"
}


show_linux_menu() {
    echo -e "${option_color}Menu Options for Linux:${NC}"
    echo -e "${option_color}1.${NC} Crack with wordlist only          						  ${CYAN}[EASY]"
    echo -e "${option_color}2.${NC} Crack with rules (Wordlist + Rules)    					  ${GREEN}[MEDIUM]"
    echo -e "${option_color}3.${NC} Crack with brute-force            						  ${YELLOW}[HARD]"
    echo -e "${option_color}4.${NC} Crack with combo (Hybrid Wordlist + Mask)  					  ${RED}[ADVANCED]"
    echo -ne "${option_color}\nPress Enter to switch to Windows.${NC}\n"
    echo "--------------------------------"
    echo -ne "${option_color}Enter option (1-4, or Q to quit): ${NC}"
}

# Function to display the menu based on OS choice
show_menu_based_on_os() {
    if [[ "$1" == "Linux" ]]; then
        show_linux_menu
    elif [[ "$1" == "Windows" ]]; then
        show_windows_menu
    else
        echo "Invalid OS choice"
        exit 1
    fi
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
            echo -ne "crack-wordlist.sh ${YELLOW}is Executing${NC}\n\n\n"
            if [[ "$default_os" == "Windows" ]]; then
                windows/crack-wordlist.sh
            elif [[ "$default_os" == "Linux" ]]; then
                ./crack-wordlist.sh
            fi
            ;;
        2)
            echo -ne "Executing crack-rule script: "
            animate_text "..." 0.1
            echo -e "crack-rule.sh ${YELLOW}is Executing${NC}\n\n\n"
            if [[ "$default_os" == "Windows" ]]; then
                windows/crack-rule.sh
            elif [[ "$default_os" == "Linux" ]]; then
                ./crack-rule.sh
            fi
            ;;
        3)
            echo -ne "Executing crack-bruteforce script: "
            animate_text "..." 0.1
            echo -e "crack-bruteforce.sh ${YELLOW}is Executing${NC}\n\n\n"
            if [[ "$default_os" == "Windows" ]]; then
                windows/crack-bruteforce.sh
            elif [[ "$default_os" == "Linux" ]]; then
                ./crack-bruteforce.sh
            fi
            ;;
        4)
            echo -ne "Executing crack-combo script: "
            animate_text "..." 0.1
            echo -e "crack-combo.sh ${YELLOW}is Executing${NC}\n\n\n"
            if [[ "$default_os" == "Windows" ]]; then
                windows/crack-combo.sh
            elif [[ "$default_os" == "Linux" ]]; then
                ./crack-combo.sh
            fi
            ;;
        [Qq])
            echo -ne "Exiting: "
            animate_text "..." 0.1
            echo -e "${YELLOW}Done!${NC}"
            echo -e "${YELLOW}Exiting...${NC}"
            exit 0
            ;;
        [Xx])
            # If the user selected option "Other Scripts", execute Windows scripts
            execute_windows_scripts
            ;;

        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            ;;
    esac
}

# Function to execute Windows scripts
execute_windows_scripts() {
    # Check if the Windows scripts directory exists
    if [[ -d "windows" ]]; then
        # Loop through the Windows scripts directory and execute each script
        for script in "windows"; do
            if [[ -f "$script" ]]; then
                echo "Executing Windows script: $script"
                # Add code to execute Windows script
            fi
        done
    else
        echo "Windows scripts directory not found: '$windows_scripts_dir'"
    fi
}

# Function to save successful settings
save_settings() {
    local session="$1"
    local path_wordlists="$2"
    local default_wordlist="$3"
    local mask="$4"
    local rule="$5"
    local plaintext_file="plaintext.txt"
    
    status+="\nSession: $session"
    status+="\nWordlist Path: $path_wordlists/$default_wordlist"
    status+="\nMask: $mask"
    status+="\nRule: $rule"
    status+="\nPlaintext: $(cat $plaintext_file)"
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
            echo -e "${GREEN}Command >>${NC} hashcat --session="$session" -m "$default_hashmode" hash.hc22000 -a 0 -w 4 --outfile-format=2 -o plaintext.txt "$default_wordlists/$default_wordlist""
            hashcat --session "$session" --restore
            exit 0
        fi
    fi
}

# Function to save all the results
save_logs() {
    mkdir "$session"
    mv "$session" logs
    echo -e "$status" > status.txt
    mv status.txt "logs/$session"
    mv plaintext.txt "logs/$session"
}
