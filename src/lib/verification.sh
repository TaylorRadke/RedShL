# -----------------------------------------------------
# VERIFICATION.SH
# - Functions related to verifying changes
# -----------------------------------------------------

# VERIFICATION PROCESS
verify_tracked_directory() {
  printf "\033[1A\033[2K"
  printf "\rBeginning verification:\n\n"
  printf "Mapping current state of directory...in progress"

  # If we aren't using our own verification file
  if [ $v_flag_set = "false" ]
  then
    current_tracked_state="default_state_tracking" # Name our tracked state as the default
    create_verification_state $current_tracked_state # Create a verification file for this tracked state
  fi

  set_base_file # Find wheather [state tracking] or [verification file] had more files in it.
  get_file_name_padding # Does padding such that the output is given in a nice format

  printf "\rMapping current state of directory...complete    \n"
  printf "Verifiying initial state with current state\n"
  
  compare_verification_states # Compare the two states (main comparison function)

  if [ $c_flag_set = "false" ]
  then
    rm $verification_file
  fi

  if [ $v_flag_set = "false" ]
  then
    rm $current_tracked_state
  fi

  printf "Verification finished with %d failing\n" "$file_verification_fail_count"
}

# GET FILE NAME FROM COMMAR SEPERATED LIST
get_file_name(){
  IFS="," # Removes the commars
  i=0
  for field in $base_state
  do
    if [ $i -eq 3 ]
    then
      file_name="$field"
      base_name=$(basename $field)
    fi
    i=$((i+1))
  done
}

# CHECK WHICH DIRECTORY HAS THE MOST FILES IN IT
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
#          file1       passed
#          file2       passed
#/a/b/dir/file         failed
# As we see, all the filenames and pass/fails meet up
get_file_name_padding(){
  f_name_padding=0
  while IFS= read -r base_state
  do
    IFS=","
    i=0
    for field in $base_state
    do
      if [ $i -eq 3 ]
      then
        file_name=$(basename $field)
        if [ ${#file_name} -gt $f_name_padding ]
        then
          f_name_padding="${#file_name}"
        fi
      fi
      i=$((i+1))
    done
  done < $base_file
}

# COMPARE VERIFICATION
compare_verification_states() {
    file_verification_fail_count=0
    while IFS= read -r base_state # For each line of our base state (each file/dir)...
    do
      base_state_inode=$(echo "$base_state" | grep -o "^\w*") # Grab the inode
      get_file_name
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

      # Output this if we have the -o flag.
      if [ $o_flag_set = "true" ]
      then
        if [ $inode_match = "false" ] || [ "$state_verification" = "failed" ]
        then
          printf "%${f_name_padding}s\t ✗ Failed\n" "${base_name}"
          printf "%s,fail\n" "${file_name}" >> $output_file
        else
          printf "%${f_name_padding}s\t ✔ Passed\n" "${base_name}"
          printf "%s,pass\n" "${file_name}" >> $output_file
        fi
      fi
    done <$base_file
}