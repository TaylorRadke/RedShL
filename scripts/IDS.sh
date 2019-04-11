#This is the main script that is called to run Intrusion Detection System

#bold and normal text for formatting
bold=$(tput bold)
normal=$(tput sgr0)
italics=$(tput sitm)
underline=$(tput smul)
reset_underline=$(tput rmul)
standout=$(tput smso)
end_standout=$(tput rmso)

#Help function to show how the program should be called
#What options are available for the program and how they should be provided
function get_help(){
    echo -e "${bold}Usage${normal}: bash IDS.sh ${italics}file${normal} [${bold}options${normal}]\n
    ${bold}OPTIONS\n
    \t-c name${normal}\t  Create a verification file called ‘${bold}name${normal}’ also display a message '${bold}File created${normal}'\n
    \t${bold}-o name${normal}\t  Display the results on the screen also save the outputs to output file ‘${bold}name${normal}’ \n
    \t${bold}--help${normal}\t  Displays a usage message and exits successfuly"
    exit 0
}

#get_args is a function that gets commandline argument flags if provided and stores the flag in flags_set array
#and its associated value in flag_vals
function get_args(){
    flag_count=0
    for (( i=1; i<=$#; i++)); do
        if [ ${!i} = "-o" ] || [ ${!i} = "-c" ]; then
            flags_set[$flag_count]=${!i}
            j=$((i+1))
            if [[ ${!j} != "" ]]; then
                flag_vals[$flag_count]=${!j}
            fi
            flag_count=$((flag_count+1))
        elif [ ${!i} = "--help" ]; then
            get_help
        fi
    done

        #Check for missing flag values
    if [[ ${#flags_set[@]} -ne ${#flag_vals[@]} ]]; then
        echo "Missing an argument"
        exit 1
    fi
}

#Check if no arguments are provided
if [ $# -eq 0 ]; then
    get_help
else
    get_args $@
fi