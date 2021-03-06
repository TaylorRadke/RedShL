# -----------------------------------------------------
# VERIFICATION.SH
# - Functions related to verifying changes
# -----------------------------------------------------

# VERIFICATION PROCESS
verify_tracked_directory() {
  printf "\033[1A\033[2K\033[1D"

  printf "Beginning verification:\n"
  # If we aren't using our own verification file
  if [ $v_flag_set = "false" ]
  then
    current_tracked_state="default_state_tracking" # Name our tracked state as the default
    create_verification_state $current_tracked_state # Create a verification file for this tracked state
  fi

  set_base_file # Find whether [state tracking] or [verification file] had more files in it.
  get_file_name_padding # Does padding such that the output is given in a nice format
  
  printf "Verifiying initial state with current state:\n\n"
  
  compare_verification_states # Compare the two states (main comparison function)

  #Delete verification_file if the user did not request one to be created
  if [ $c_flag_set = "false" ]
  then
    rm $verification_file
  fi

  #Delete the current tracked_state if it v flag not set because the input of -v is set to current_tracked_state
  if [ $v_flag_set = "false" ]
  then
    rm $current_tracked_state
  fi

  if [ $o_flag_set = 'true' ] || [ $display_results_flag_set = "true" ]
  then
    printf "\n"
  fi

  printf "Verification finished with %d failing\n" "$file_verification_fail_count"

  if [ $o_flag_set = 'true' ]
  then
    printf "Results written to file: %s\n" "$output_file"
  fi

}

# GET FILE NAME FROM COMMAR SEPERATED LIST
get_file_attrs(){
  IFS="," # Set the internal field seperator to comma
  i=0
  for field in $base_state
  do
    case $i in
      0)
        file_node="$field"
        ;;
      1)
        file_name="$field"
        ;;
      2)
        file_type="$field"
        ;;
      3)
        file_absolute_path="$field"
        ;;
    esac
    i=$((i+1))
  done
}

# CHECK WHICH VERIFICATION STATE CONTAINS THE MOST FILES
# This means that we won't miss any files if the new (potentially changed) directory
# happend to have more lines in it.
set_base_file(){
  initiaL_verification_file_lines=$(wc -l "$verification_file" | grep -o "\w* ")
  current_verification_file_lines=$(wc -l "$current_tracked_state" | grep -o "\w* ")

  # Set base file to file with most lines to account for missing or added files
  if [ $initiaL_verification_file_lines -ge $current_verification_file_lines ] # if more in verification
  then
    base_file="$verification_file" # base will be verification
    checking_file="$current_tracked_state"
  else # else if more in tracked state
    base_file="$current_tracked_state" # base will be tracked state
    checking_file="$verification_file"
  fi
}

# ADDS PADDING TO FORMAT OUTPUT
# E.g.
#        file1   passed
#        file2   passed
#/a/b/dir/file   failed
# As we see, all the filenames and pass/fails meet up
get_file_name_padding(){
  f_name_padding=0
  while IFS= read -r base_state
  do
    get_file_attrs 
    if [ ${#file_name} -gt $f_name_padding ]
    then
      f_name_padding="${#file_name}"
    fi
  done < $base_file
}

# COMPARE VERIFICATION
compare_verification_states() {
    file_verification_fail_count=0
    file_count=1 #Counter to display current file number 

    while IFS= read -r base_state # For each line of our base state (each file/dir)...
    do
      base_state_inode=$(echo "$base_state" | grep -o "^\w*") # Grab the inode
      get_file_attrs
      inode_match="false"

      while IFS= read -r checking_state # For each line of our checking file (each file/dir)
      do
        checking_state_inode=$(echo "$checking_state" | grep -o "^\w*") # Grab the inode

        # If the two inodes are equal
        # (Meaning we're looking at the same file)
        if [ $base_state_inode = $checking_state_inode ]
        then
          inode_match="true"

          # Check if the two matching lines are equal
          if [ "$base_state" = "$checking_state" ]
          then
            state_verification="passed"

          else
            state_verification="failed"
          fi
        fi
      done <$checking_file

      # Increase our fail count if inode or verification state failed
      # E.g. something was tampered with within that file.
      if [ $inode_match = "false" ] || [ "$state_verification" = "failed" ]
      then
        file_verification_fail_count=$((file_verification_fail_count+1))
      fi

      # Output this if we have the -o  or --display-results flag set.
      if [ "$display_results_flag_set" = "true" ]
      then
        if [ $inode_match = "false" ] || [ "$state_verification" = "failed" ]
        then

          printf "%2d\t%${f_name_padding}s\t ✗ Failed\n" "$file_count" "${file_name}"

          if [ "$o_flag_set" = "true" ]
          then
            printf "%s,fail\n" "${file_absolute_path}" >> $output_file
          fi
        else

          printf "%2d\t%${f_name_padding}s\t ✔ Passed\n" "$file_count" "${file_name}"

          if [ "$o_flag_set" = "true" ]
          then
            printf "%s,pass\n" "${file_absolute_path}" >> $output_file
          fi
        fi
      fi
      file_count=$((file_count + 1))
    done <$base_file
}