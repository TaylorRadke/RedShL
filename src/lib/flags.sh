#Optional FLAGS the user can provide
FLAGS=("-o" "-c")

#Checks if given input is a flag in the FLAGS array
function is_flag {
    is_flag_result=0

    #Loop through FLAGS array checking if the given input matches
    for flag in ${FLAGS[@]}; do
        if [[ $1 = $flag ]]; then
            is_flag_result=1
            return
        fi
    done
}

#Get the input file which lists directories and files to watch
function check_file {
    #Matches first argument with a string containing a .txt pattern
    # '$' in pattern ensures that file extension ends with .txt and terminates
    # So that .txt.* will not match
    file_list=$(echo $1 | grep -e .txt$)
    
    #If the file provided did not match the pattern then exit
    if [[ $file_list = "" ]]; then
        echo "RedShL: file: first argument must be a .txt file"
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

    flag_count=0
    #Loop through args from second arg(args after file arg)
    for (( i=2; i<=$#;i++)); do
        #Check if current arg is a flag
        is_flag ${!i}
        if [ $is_flag_result -eq 1 ]; then
            #Check if next arg is a flag
            j=$((i+1))
            is_flag ${!j}

            #Check if next arg is flag or empty string
            if [[ $is_flag_result -eq 1 ]] || [[ ${!j} == "" ]]; then
                echo "$0: ${!i}: option requires an argument"
                echo "Try 'bash RedShL.sh --help' for help"
                exit
            else
                #Removes leading dashes from the flag, e.g -c -> c
                flag=$(echo ${!i} | sed "s/-//g")
                if [ $flag = "c" ]; then
                    c_FLAG=${!j}
                    c_flag_set=true
                elif [ $flag = "o" ]; then
                    o_FLAG=${!j}
                    o_flag_set=true
                fi
            fi
        fi
    done
}