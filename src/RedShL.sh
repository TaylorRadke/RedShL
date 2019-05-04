#!/bin/bash

# -----------------------------------------------------
# REDSHL.SH
# - Main of the program
# -----------------------------------------------------

# Import functions from lib/
. ./lib/flags.sh
. ./lib/state.sh
. ./lib/verification.sh

# DISPLAYING HELP OPTIONS OF PROGRAM
get_help() {
    printf "Usage: sh RedShL.sh [options]\n\n"
    printf "options:\n\n"
    printf "  -c name\t Create a verification file called ‘name’ also display a message 'File created'\n"
    printf "  -h, --help\t Display a help message and exit\n"
    printf "  -o name\t Display the results on the screen also save the outputs to output file ‘name'\n"
    printf "  -t directory\t Choose the directory to track, skipping user input\n"
    printf "  -v file\t Select a verification file to use to check against the current state\n"
    exit
}

# Was the -h or --help parameter called?
help_arg_provided $@ 

# Parse all arguments from commandline and see which flags were used
parse_args "$@"

# Print program header 
printf "=-------------------------------------------------------------=\n"
printf "|                             RedShL                          |\n"
printf "=-------------------------------------------------------------=\n"
printf "Need Help? Try 'sh RedShL.sh --help'\n\n"

# -c option used -> create a verification folder.
if [ $c_flag_set = "true" ]; then
  create_verification_file
fi

# Get the directory name to track (If we aren't already tracking it with -t)
if [ $t_flag_set = "false" ]; then
  #Prompt the user for directory, -e option allows for file autocompletion (bash only)
  read -e -p"Enter a directory to monitor: " dir_tracked # Prompt the user to enter a name. Store it in the dir_tracked.
  printf "\033[1A\033[K"
fi

# Check if dir_tracked is actually a directory
if [ -d "$dir_tracked" ]; then # If dir_tracked is directory (-d)
  printf "$dir_tracked:\n\n"
  printf "Mapping current state of directory...in progress"
else
  printf "Error: $dir_tracked is not a directory\n"
  exit
fi

# Start mapping the contents of dir_tracked to the verification file
create_verification_state "$verification_file"


# Ask user if they would like to begin verification
if [ $v_flag_set = "false" ]
then
  while read -p "Begin verification [y/n]: " begin_verify; do
    if [ $begin_verify = 'y' ]; then
      break
    else
      printf "\033[1A\033[K"
    fi
  done
fi

# Once the user has decided (or they have used -v) -> Verify 
verify_tracked_directory
