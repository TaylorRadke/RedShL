#!/bin/bash
#This is the main script that is called to run Intrusion Detection System


#All optional flags the user can provide
flags=("-o" "-c" "--help")


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
function get_help {
    echo -e "${bold}Usage${normal}: bash IDS.sh ${italics}file${normal} [${bold}options${normal}]\n
    ${bold}OPTIONS\n
    \t-c name${normal}\t  Create a verification file called ‘${bold}name${normal}’ also display a message '${bold}File created${normal}'\n
    \t${bold}-o name${normal}\t  Display the results on the screen also save the outputs to output file ‘${bold}name${normal}’ \n
    \t${bold}--help${normal}\t  Displays a usage message and exits successfuly"
    exit 0
}

#Checks if given input is a flag in the flags array
function is_flag {
    is_flag_result=0

    for flag in ${flags[@]}; do
        if [[ $1 = $flag ]]; then
            is_flag_result=1
            return
        fi
    done
}

#get_args is a function that gets the flags provided by the user
#Checking if all required arguments are provided for each flag
function get_flags {
    flag_count=0
    for (( i=2; i<=$#;i++)); do
        #Check if current arg is a flag
        is_flag ${!i}
        if [ $is_flag_result -eq 1 ]; then
            #Check if next arg is a flag
            j=$((i+1))
            is_flag ${!j}
            if [[ $is_flag_result == 1 ]] || [[ ${!j} == "" ]]; then
                echo "$0: ${!i}: option requires an argument"
                exit
            else
                flags_set[$flag_count]=${!i}
                flag_vals[$flag_count]=${!j}
                flag_count=$((flag_count+1))
            fi
        elif [ ${!i} = "--help" ]; then
            get_help
        fi
    done
}

#Looks through the provided args and checks if the user asked for help
function help_arg_provided {
    for i in "$@"; do
        if [ $i = "--help" ]; then
            get_help
        fi
    done
}



#Main...

#Check if no arguments are provided
if [[ $# -eq 0 ]]; then
    get_help
else
    help_arg_provided $@
    get_flags $@
fi