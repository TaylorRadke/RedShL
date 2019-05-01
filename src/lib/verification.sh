verify_tracked_directory() {
  printf "\033[1A\033[2K"
  printf "\rBeginning verification:\n\n"
  printf "Mapping current state of directory...in progress"
  #Map the current state of the tracked directory
  create_verification_state "current-tracked-state"
  printf "\rMapping current state of directory...complete    \n"
  printf "Verifiying initial state with current state\n"
  compare_verification_states
}

compare_verification_states() {
    initiaL_verification_file_lines=$(wc -l $verification_file | grep -o "\w* ")
    current_verification_file_lines=$(wc -l "current-tracked-state" | grep -o "\w* ")

    if [ $initiaL_verification_file_lines -ge $current_verification_file_lines ]
    then
      base_file="$verification_file"
      checking_file="current-tracked-state"
    else
      base_file="current-tracked-state"
      checking_file="$verification_file"
    fi

    while IFS= read -r base_state
    do
      base_state_inode=$(echo "$base_state" | grep -o "^\w*")

      inode_match="false"
      state_verification_passed="false"

      while IFS= read -r checking_state
      do
        checking_state_inode=$(echo "$checking_state" | grep -o "^\w*")

        if [ $base_state_inode = $checking_state_inode ]
        then
          inode_match="true"
          if [ "$initial_state" = "$current_state" ]
          then
            state_verification_passed="true"
          fi
        fi
      done <"$checking_file"

      if [ $inode_match = "false" ] || [ "$state_verification_passed" = "false" ]
      then
        echo "file failed"
      else
        echo "file passed"
      fi
    done <"$base_file"
}
