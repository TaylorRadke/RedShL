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

    while IFS= read -r initial_state; do
      initial_state_inode=$(echo "$initial_state" | grep -o "^\w*")

      while IFS= read -r current_state; do
        current_state_inode=$(echo "$current_state" | grep -o "^\w*")

        if [ $initial_state_inode = $current_state_inode ]; then
          line_mathced=true
          if [ "$initial_state" = "$current_state" ]
          then
            echo "file passed"
          else
            echo "file failed"
          fi
        fi
      done <"current-tracked-state"
    done <"$verification_file"
}
