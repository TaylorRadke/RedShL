verify_tracked_directory() {
  printf "\033[1A\033[2K"
  printf "\rBeginning verification:\n\n"
  printf "Mapping current state of directory...in progress"
  #Map the current state of the tracked directory
  current_tracked_state="currenttrackedstate"
  create_verification_state $current_tracked_state

  printf "\rMapping current state of directory...complete    \n"
  printf "Verifiying initial state with current state\n"
  compare_verification_states
  rm $current_tracked_state
  printf "Verification finished with %d failing\n" "$file_verification_fail_count"
}

#Get the file name from the comma seperated list
get_file_name(){
  IFS=","
  i=0
  for field in $base_state
  do
    if [ $i -eq 3 ]
    then
    file_name=$(basename $field)
    fi
    i=$((i+1))
  done
}

set_base_file(){
  initiaL_verification_file_lines=$(wc -l "$verification_file" | grep -o "\w* ")
  current_verification_file_lines=$(wc -l "$current_tracked_state" | grep -o "\w* ")

  #Set base file to file with most lines to account for missing or added files
  if [ $initiaL_verification_file_lines -ge $current_verification_file_lines ]
  then
    base_file="$verification_file"
    checking_file="$current_tracked_state"
  else
    base_file="$current_tracked_state"
    checking_file="$verification_file"
  fi
}

compare_verification_states() {
    set_base_file

    file_verification_fail_count=0
    while IFS= read -r base_state
    do
      base_state_inode=$(echo "$base_state" | grep -o "^\w*")

      get_file_name

      inode_match="false"

      while IFS= read -r checking_state
      do
        checking_state_inode=$(echo "$checking_state" | grep -o "^\w*")

        #Check for matching inodes to indicate that the two lines reference the same file
        if [ $base_state_inode = $checking_state_inode ]
        then
          inode_match="true"
          #Check if the two matching lines are equal
          if [ "$initial_state" = "$current_state" ]
          then
            state_verification="passed"
          else
            state_verification="failed"
          fi
        fi
      done <$checking_file

      if [ $inode_match = "false" ] || [ "$state_verification_passed" = "failed" ]
      then
        file_verification_fail_count=$((file_verification_fail_count+1))
      fi

      if [ $o_flag_set = "true" ]
      then
        if [ $inode_match = "false" ] || [ "$state_verification_passed" = "failed" ]
        then
          printf "%s FAILED\n" "${file_name}"
        else
          printf "%s PASSED\n" "${file_name}"
        fi
      fi
    done <$base_file
}
