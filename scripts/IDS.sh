#This is the main script that is called to run Intrusion Detection System

#bold and normal text for formatting
bold=$(tput bold)
normal=$(tput sgr0)

#Help function to show how the program should be called
#What options are available for the program and how they should be provided
function get_help(){
    echo "${bold}Usage${normal}: bash IDS.sh file [${bold}options${normal}]"$'\n'
    echo "${bold}OPTIONS"$'\n'
    echo " -c name${normal}    Create a verification file called ‘name’ also display a message 'File created'"
    echo " ${bold}-o name${normal}    Display the results on the screen also save the outputs to an output file"
    echo " ${bold}--help${normal}     Displays a usage message and exit"
    exit
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
        exit
    fi
}

#Check if no arguments are provided
if [ $# -eq 0 ]; then
    get_help
else
    get_args $@
fi