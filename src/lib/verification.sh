function verify_tracked_directory {
  printf "\033[1A\033[2K"
  printf "\rBeginning verification\n"
  printf "Mapping current state of directory...in progress"
  #Map the current state of the tracked directory
  create_verification_state
  printf "\rMapping current state of directory...complete    \n"
  printf "Verifiying initial state with current state:\n\n"
  compare_verification_states
  printf "\nVerification complete with %d failing\n" "${fail_count}"
}

function compare_verification_states {
  fail_count=0
  for tracked_file_inode in ${verification_inodes[@]}; do

    #Get the initial state from the initial_state hash map
    initial_state=${initial_state_map[$tracked_file_inode]}
    #Get the current state from file_map hash map
    current_state=${file_map[$tracked_file_inode]}

    #Get the file name from the initial state
    file_name=$(cut -d "," -f2 <<< $initial_state)
    #Take only base file name from file_name
    file_name=$(basename $file_name)

    #Add padding based on longest filename
    printf "%$((file_name_max_length+1))s\t " "${file_name}"

    #Compare initial state and current state strings
    if [[ $initial_state != $current_state ]]; then
      printf "\u274c Failed\n"
      fail_count=$((fail_count+1))
    else
      printf "\u2714 Passed\n"
    fi
  done;
}
