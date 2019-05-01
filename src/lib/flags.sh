

#Optional FLAGS the user can provide, "-t", "-o","-c"


#Checks if given input is a flag in the FLAGS array
is_flag() {
    is_flag_result=0
    input=$1
    #Check if the input matches any of the defined FLAGS
    for flag in ${FLAGS[@]}; do
        if [ $1 = "-c" ] || [ $1 = "-o" ] || [ $1 = "-t" ]; then
            is_flag_result=1
            return
        fi
    done

    #Check if string starts with '-' in which case it is not an option defined
    if [ "${input:0:1}" = "-" ]; then
      printf "$0: $1: unrecognised option\n"
      printf "Try 'bash RedShL.sh --help' for help\n"
      exit
    fi
}

#Check if the user provided the --help flag
help_arg_provided() {
    for arg in "$@"; do
      if [ $arg = '-h' ] || [ $arg = "--help" ]; then
        get_help
      fi
    done
}

#parse_args gets the FLAGS provided by the user when starting the program
#Checking if all required arguments are provided for each flag
parse_args() {

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
                flag=${!i}

                #Turn flag on and give its value if set
                if [ $flag = "-c" ]; then
                    verification_file=${!j}
                    c_flag_set=true
                    echo "c flag"
                elif [ $flag = "-o" ]; then
                    output_file=${!j}
                    o_flag_set=true
                    echo "o flag"
                elif [ $flag = "-t" ]; then
                    t_flag_set=true
                    dir_tracked="${!j}"
                fi
            fi
        fi
    done
}
