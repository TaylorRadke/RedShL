#!/bin/bash

#Import functions from lib/
source lib/flags.sh
source lib/verification.sh

#Help function to show how the program should be called
#What options are available for the program and how they should be provided
function get_help {
    echo -e "Usage: bash RedShL.sh file [OPTIONS]\n"
    echo -e "file\tA text file containing a list of files and directories for RedShL to monitor\n"
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

echo "Enter a directory to monitor for intrusions: "
read dir_tracked

echo $dir_tracked


# #Save states of input file contents to verification file in ./tracking
if [ $c_flag_set == true ]; then
    create_verification_file
fi
verify_input_file
