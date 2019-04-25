#Optional FLAGS the user can provide
FLAGS=("-o" "-c" "--help")

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

#Get the input file which lists directories and files to watch
function check_file {
    file=$(echo $1 | grep -e .txt)

    if [[ $file = "" ]]; then
        echo "RedShL: file: first argument must be a text file"
        echo "Try 'bash RedShL.sh --help' for help"
        exit
    fi
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
    help_arg_provided $@
    check_file $@

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
                echo "Try 'bash RedShL.sh --help' for help"
                exit
            else
                #Removes the leading dash from the flag, e.g -c = c
                flag=$(echo ${!i} | sed "s/-//g")
                if [[ $flag = "c" ]]; then
                    c_FLAG=${!j}
                elif [[ $flag = "o" ]]; then
                    o_FLAG=${!j}
                fi
            fi
        fi
    done
}