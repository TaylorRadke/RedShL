#!/bin/bash

#Import functions from lib/
source lib/flags.sh
source lib/verification.sh

#Help function to show how the program should be called
#What options are available for the program and how they should be provided
function get_help {
    echo -e "Usage: bash RedShL.sh [OPTIONS]\n"
    echo -e "OPTIONS\n"
    echo -e "\t-c name\t  Create a verification file called ‘name’ also display a message 'File created'\n"
    echo -e "\t--help\t  Display a help message and exit\n"
    echo -e "\t-o name\t  Display the results on the screen also save the outputs to output file ‘name'\n"
    exit
}

#Check if --help is provided
help_arg_provided $@

# #Parse args from commandline, from lib/flags
parse_args $@

echo "=-----------------------------------------------------------="
echo "|                            RedShL                         |"
echo -e "=-----------------------------------------------------------=\n"


echo "Cteate verification file: ${c_flag_set}"
printf "Display Verification Results: ${o_flag_set}\n\n\n"

echo "Enter a directory to monitor:"
read dir_tracked

#Check if dir_tracked read is a directory
if [ -d $dir_tracked ]; then
  echo -e "\n$dir_tracked: Saving current state of directory for verification"
else
  echo "Error: $dir_tracked is not a directory"
  exit
fi
