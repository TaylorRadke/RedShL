#Optional FLAGS the user can provide
FLAGS=("-o" "-c" "--help")

#Help function to show how the program should be called
#What options are available for the program and how they should be provided
function get_help {
    echo -e "${bold}Usage${normal}: bash IDS.sh ${underline}FILE${reset_underline} [${bold}options${normal}]\n
    ${underline}${italics}file${normal}${reset_underline}\n 
    ${bold}OPTIONS\n
    \t-c name${normal}\t  Create a verification file called ‘${bold}name${normal}’ also display a message '${bold}File created${normal}'\n
    \t${bold}--help${normal}\t  Display a help message and exit\n
    \t${bold}-o name${normal}\t  Display the results on the screen also save the outputs to output file ‘${bold}name${normal}’ \n
    "
    exit
}

#Checks if given input is a flag in the FLAGS array
function is_flag {
    is_flag_result=0

    for flag in ${FLAGS[@]}; do
        if [[ $1 = $flag ]]; then
            is_flag_result=1
            return
        fi
    done
}

#parse_args gets the FLAGS provided by the user when strating the program
#Checking if all required arguments are provided for each flag
function parse_args {
    flag_count=0
    for (( i=2; i<=$#;i++)); do
        #Check if current arg is a flag
        is_flag ${!i}
        if [ $is_flag_result -eq 1 ]; then
            #Check if next arg is a flag
            j=$((i+1))
            is_flag ${!j}
            if [[ $is_flag_result -eq 1 ]] || [[ ${!j} == "" ]]; then
                echo "$0: ${!i}: option requires an argument"
                exit
            else
                FLAGS_set[$flag_count]=${!i}
                flag_vals[$flag_count]=${!j}
                flag_count=$((flag_count+1))
            fi
        elif [ ${!i} = "--help" ]; then
            get_help
        fi
    done
}

#Check if the user provided the --help flag
function help_arg_provided {
    for i in "$@"; do
        [ $i = "--help" ] && { get_help; }
    done
}