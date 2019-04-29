#!/bin/bash

#Import functions from lib/
source lib/flags.sh
source lib/state_mapping.sh
source lib/verification.sh

#Help function to show how the program should be called
#What options are available for the program and how they should be provided
function get_help {
    printf "Usage: bash RedShL.sh [OPTIONS]\n\n"
    printf "OPTIONS\n\n"
    printf "\t-c name\t  Create a verification file called ‘name’ also display a message 'File created'\n\n"
    printf "\t--help\t  Display a help message and exit\n\n"
    printf "\t-o name\t  Display the results on the screen also save the outputs to output file ‘name'\n\n"
    exit
}

#Check if --help is provided
help_arg_provided $@

# #Parse args from commandline, from lib/flags
parse_args $@

#Program header to print
printf "=-------------------------------------------------------------=\n"
printf "|                             RedShL                          |\n"
printf "=-------------------------------------------------------------=\n"

printf "Need help? Try 'bash RedShL.sh --help'\n\n\n"

if [ $c_flag_set = true ]; then
  create_verification_file
fi

#Prompt the user to enter direcotry name then store it in dir_tracked
#-e allows for autocompletion of files names and directories using tab
read -e -p "Enter a directory to monitor: " dir_tracked

#delete previous line
printf "\033[1A\033[2K"

#Check if dir_tracked read is a directory
if [ -d $dir_tracked ]; then
  printf "$dir_tracked: Map current state of directory...in progress"
else
  printf "Error: $dir_tracked is not a directory\n"
  exit
fi
# for node in "${dir_inodes[@]}"; do
#   echo ${initial_state_map[$node]}
# done

#Get the initial state of the directory dir_tracked and map its files attributes by
#the files inode and copy it into initial_state_map
map_initial_directory_state

printf "\r$dir_tracked: Map current state of directory...complete   \n"

printf "Tracking ${#dir_inodes[@]} files\n\n"

read -p "Begin verification[y/n]: " begin_verify

while [ ! $begin_verify = 'y' ]; do
    printf "\033[1A\033[2K"
    read -p "Begin verification[y/n]: " begin_verify
done

verify_tracked_directory
