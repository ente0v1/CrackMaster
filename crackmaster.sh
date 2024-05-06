#!/bin/bash

# Source the functions library
source ./functions.sh
source ./fsociety00.dat

# Define parameters
define_default_parameters
define_colors

# Function to display the menu based on OS choice
show_menu_based_on_os() {
    if [[ "$1" == "linux" ]]; then
        show_linux_menu
    elif [[ "$1" == "windows" ]]; then
        show_windows_menu
    else
        echo "Invalid OS choice"
        exit 1
    fi
}

# Loop to keep displaying the menu and handling options until the user chooses to quit
while true; do
    clear_screen
    show_title
    show_menu_based_on_os "$default_os"  # Show menu based on default OS
    read -r user_option  # Read user input

    # Handle the user's selected option
    handle_option "$user_option"
    echo "User option: $user_option"
    
    # Pause briefly to allow the user to read previous output before clearing the screen
    sleep 3

    # If the user selected "Quit", exit the loop
    if [[ "$user_option" == [Qq] ]]; then
        break
    fi
done
