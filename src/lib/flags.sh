#Optional FLAGS the user can provide
FLAGS=("-o" "-c" "--help")

#Help function to show how the program should be called
#What options are available for the program and how they should be provided
function get_help {
    echo -e "Usage: bash RedShL.sh file [OPTIONS]\n"
    echo -e "file\n" 
    echo -e "OPTIONS\n"
    echo -e "\t-c name\t  Create a verification file called ‘name’ also display a message 'File created'\n"
    echo -e "\t--help\t  Display a help message and exit\n"
    echo -e "\t-o name\t  Display the results on the screen also save the outputs to output file ‘name'\n"
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
    file=$(echo $1 | grep -e .txt)

    if [[ $file = "" ]]; then
        echo "RedShL: file: first argument must be a text file"
        echo "Try bash RedShL.sh --help"
        exit
    fi

    for (( i=2; i<=$#;i++)); do
        #Check if current arg is a flag
        is_flag ${!i}
        if [ $is_flag_result -eq 1 ]; then
            #Check if next arg is a flag
            j=$((i+1))
            is_flag ${!j}
            if [[ $is_flag_result -eq 1 ]] || [[ ${!j} == "" ]]; then
                echo "$0: ${!i}: option requires an argument"
                echo "Try bash RedShL.sh --help"
                exit
            else
                #Removes the leading dash from the flag, e.g -c = c
                FLAGS_set[$flag_count]=$(echo ${!i} | sed "s/-//g")
                FLAGS_vals[$flag_count]=${!j}
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