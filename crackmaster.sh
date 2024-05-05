#!/bin/bash
# Source the functions library
source "$default_scripts/functions.sh"
source "$default_scripts/fsociety00.dat"

# Define parameters
define_default_parameters
define_colors

# Loop to keep displaying the menu and handling options until the user chooses to quit
while true; do
	clear_screen
	show_title
	show_menu
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
