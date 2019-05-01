#!/bin/sh


#Import functions from lib/
. ./lib/flags.sh
. ./lib/state_mapping.sh
. ./lib/verification.sh

#Help function to show how the program should be called
#What options are available for the program and how they should be provided
function get_help {
    printf "Usage: bash RedShL.sh [options]\n\n"
    printf "options:\n\n"
    printf "  -c name\t Create a verification file called ‘name’ also display a message 'File created'\n\n"
    printf "  -h, --help\t Display a help message and exit\n\n"
    printf "  -o name\t Display the results on the screen also save the outputs to output file ‘name'\n\n"
    printf "  -t directory\t Choose the directory to track, skipping user input\n\n"
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
if [ ! $t_flag_set = true ]; then
  read -e -p "Enter a directory to monitor: " dir_tracked
fi

#delete previous line
printf "\033[1A\033[2K"

#Check if dir_tracked read is a directory
if [ -d $dir_tracked ]; then
  printf "$dir_tracked:\n\n"
  printf "Mapping current state of directory...in progress"
else
  printf "Error: $dir_tracked is not a directory\n"
  exit
fi
#Get the initial state of the directory dir_tracked and map its files attributes by
#the files inode and copy it into initial_state_map
map_initial_directory_state

#Replaced in progress line with complete
printf "\rMapping current state of directory...complete   \n"

#Print how many files are being tracked
printf "Tracking ${#verification_inodes[@]} files\n\n"

#Ask the user if they would like to begin verifyication
while read -p "Begin verification [y/n]: " begin_verify; do
  if [ $begin_verify = 'y' ]; then
    break
  else
    printf "\033[1A\033[2K"
  fi
done

verify_tracked_directory
