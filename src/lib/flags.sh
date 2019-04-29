#Optional FLAGS the user can provide
FLAGS=("-o" "-c")

#Checks if given input is a flag in the FLAGS array
function is_flag {
    is_flag_result=0

    #Check if the input matches any of the defined FLAGS
    for flag in ${FLAGS[@]}; do
        if [[ $1 = $flag ]]; then
            is_flag_result=1
            return
        fi
    done
}

#Check if the user provided the --help flag
function help_arg_provided {
    for i in "$@"; do
        [ $i = "--help" ] && { get_help; }
    done
}

#parse_args gets the FLAGS provided by the user when starting the program
#Checking if all required arguments are provided for each flag
function parse_args {

    o_flag_set=false
    c_flag_set=false

    flag_count=0
    #Loop through args from second arg(args after file arg)
    for (( i=1; i<=$#;i++)); do
        #Check if current arg is a flag
        is_flag ${!i}
        if [ $is_flag_result -eq 1 ]; then
            #Check if next arg is a flag
            j=$((i+1))
            is_flag ${!j}

            #Check if next arg is flag or empty string
            if [[ $is_flag_result -eq 1 ]] || [[ ${!j} == "" ]]; then
                printf "$0: ${!i}: option requires an argument\n"
                printf "Try 'bash RedShL.sh --help' for help\n"
                exit
            else
                #Turn flag on and give its value if set
                if [ $flag = "-c" ]; then
                    c_FLAG=${!j}
                    c_flag_set=true
                elif [ $flag = "-o" ]; then
                    o_FLAG=${!j}
                    o_flag_set=true
                fi
            fi
        fi
    done
}
