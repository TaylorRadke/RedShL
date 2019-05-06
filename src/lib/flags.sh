# -----------------------------------------------------
# FLAGS.SH
# - Functions related to flag options the user can use
# - "-t" "-o" "-c" "-v" "-h" || "--help"
# -----------------------------------------------------

# CHECKING IF HELP PARAMETERS WERE ENTERED (-h or --hh)
help_arg_provided() {
  for arg in "$@"; do # For all arguments provided
    case $arg in 
      -h|--help) # If the argument is -h or --help
        get_help # Call the get help function.
      esac
  done
}

# CHECKING CORRECT PARAMETERS WERE ENTERED (2 OR MORE)
check_flag_args(){
  #Check if the next argument is also a flag, in which case the current flag does not have
  #an appropriate argument
  next_arg_flag="$(echo "$2" | grep "^-\w*")"
  if [ $# -lt 2 ] || [ "$next_arg_flag" != "" ]
  then # If '$#' (no of parameters) is less than 2
    printf "Error: $arg: option requires an argument\n"
    printf "Try 'sh RedShL.sh --help' for help\n"
    exit
  fi
}

# CHECKING WHICH FLAGS THE USER INPUT
parse_args() {
    # Initialise all flags
    o_flag_set="false"
    c_flag_set="false"
    t_flag_set="false"
    v_flag_set="false"
    display_results_flag_set="false"

    verification_file="verification" # Name of verification file

    # Go though all elements of the parameters and check which flags were used.
    # For argument in the array of parameters...
    for arg 
    do
      case $arg in

        -o)
          check_flag_args "$@" # Did we have 2 or more parameters?
          o_flag_set="true" # Set that we are using the -o option command
          output_file="$2" # Use the second parameter as the name of the output
          display_results_flag_set="true"
          shift; shift # Clear the first two parameter items ([-c, name, -t] -> [name, -t] -> [-t])..
          ;;           # ..Already checked '-c' and don't need to check 'name'

        -c)
          check_flag_args "$@"
          c_flag_set="true"
          verification_file="$2" # Set verification file name to param 2 argument
          shift; shift
          ;;

        -t)
          check_flag_args "$@"
          t_flag_set="true"
          dir_tracked="$2" # Directory to be tracked will be the param 2 argument
          shift; shift
          ;;

        -v)
          check_flag_args "$@"
          v_flag_set="true" 
          current_tracked_state="$2" # We want to use 2nd arg as a verification file to check against current state

          # Was a valid verification file provided?
          if [ ! -f "$current_tracked_state" ] # If the file name does not exist...
          then
            printf "Error: $current_tracked_state: cannot find verification file\n"
            exit
          fi
          shift; shift
          ;;

        --display-results)
          display_results_flag_set="true"
          shift;
          ;;

        -*) # Unrecognised option
          printf "$0: $arg: unrecognised option\n"
          printf "Try 'bash RedShL.sh --help' for help\n"
          exit
      esac
    done
}