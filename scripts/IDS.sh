#!/bin/bash

#Get file from args
flags={}

function get_help () {
    echo "Usage: bash IDS.sh file [options]"$'\n'
    echo "options:"$'\n'
    echo " -c name    Create a verification file called ‘name’ also display a message 'File created'"
    echo " -o name    Display the results on the screen also save the outputs to an output file"
    exit
}

if [ $# -eq 0 ]
then
    get_help
else
    for i in $@
    do
        flag_index=0
        if [ $i = "-c" ] || [ $i = "-o" ]
        then
            flags[$flag_index]=$i
            flag_index=$(($flag_index + 1))
        elif [ $i = "--help" ]
        then
            get_help
        fi
    done
fi