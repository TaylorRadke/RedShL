#!/bin/bash

#Import functions from lib/
source lib/flags.sh

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

#Get help if no arguments are provided
[ $# -eq 0 ] && { get_help; }


#Parse args from commandline, from lib/flags
parse_args $@

echo $c_FLAG
echo $o_FLAG

rm tracking -rf
mkdir tracking
cd ./tracking

if [[ $c_FLAG != "" ]]; then
    verification_file="${c_FLAG}.txt"
    touch ${verification_file}
    echo "Verification file Created: $(pwd)/$c_FLAG"
else
    verification_file="verify.txt"
    touch ${verification_file}
fi