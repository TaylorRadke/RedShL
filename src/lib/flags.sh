#Optional FLAGS the user can provide, "-t", "-o","-c"

#Check if the user provided the -h or --help flag
help_arg_provided() {
  for arg in "$@"; do
    case $arg in
      -h|--help)
        get_help
      esac
  done
}

check_flag_missing_arg(){
  if [ $# -lt 2 ];then
    printf "Error: $arg: option requires an argument\n"
    printf "Try 'sh RedShL.sh --help' for help\n"
    exit
  fi
}

#parse_args gets the FLAGS provided by the user when starting the program
#Checking if all required arguments are provided for each flag
parse_args() {

    o_flag_set="false"
    c_flag_set="false"
    t_flag_set="false"
    v_flag_set="false"

    verification_file="verification"

    for arg
    do
      case $arg in
        -o)
          check_flag_missing_arg "$@"
          o_flag_set="true"
          output_file="$2"
          shift; shift
          ;;
        -c)
          check_flag_missing_arg "$@"
          c_flag_set="true"
          verification_file="$2"
          shift; shift
          ;;
        -t)
          check_flag_missing_arg "$@"
          t_flag_set="true"
          dir_tracked="$2"
          shift; shift
          ;;
        -v)
          check_flag_missing_arg "$@"
          v_flag_set="true"
          current_tracked_state="$2"

          if [ ! -f "$current_tracked_state" ]
          then
            printf "Error: $current_tracked_state: cannot find verification file\n"
            exit
          fi
          shift; shift
          ;;
        -*)
          printf "$0: $arg: unrecognised option\n"
          printf "Try 'bash RedShL.sh --help' for help\n"
          exit
      esac
    done
}
