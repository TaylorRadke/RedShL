# -----------------------------------------------------
# STATE.SH
# - Functions related to creating an initial verification state
# -----------------------------------------------------

#CREATE NEW VERIFICATION FILE
create_verification_file() {
    # Remove any existing verification files with the same name
    if [ -e ${verification_file} ]; then
      rm ${verification_file}
    fi
    touch ${verification_file} # Create verification file
    printf "Verification file Created: %s\n\n" "${verification_file}"
}

# PROGRESS BAR
progress_bar(){
  j=0
  percent_steps=4 # Set when to update the proress bar, e.g every 5%
  percent_padding=$((100/percent_steps)) # Padding for progress bar between bar based on percent steps
  percent_string=""

  while [ $j -le $1 ]
  do
    if [ $((j % percent_steps)) -eq 0 ]
    then
      percent_string="$percent_string#"
    fi
    j=$((j + 1))
  done
  printf "\r[%-${percent_padding}s] (%d%%)" "$percent_string" "$1"
}

# STORING ATTRIBUTES OF CONTENTS TO VERIFICATION FILE
create_verification_state() {

  #Delete previous line and print mapping in progress
  #printf "\033[1A\033[2K"
  printf "\nMapping current state of directory for $1...in progress"

  # Create a file to write to
  write_file=$1 # write file will have name of verification file

  if [ -e $write_file ]; then # If the file already exists, delete it and make a new one
    rm $write_file
    touch $write_file
  fi
  
  # Percentage bar related
  directory_file_count=$(find $dir_tracked | wc -l) # Want the no number of files in the directory
  printf "\n"
  i=1
  percent_string=""

  # For each file in the directory...
  find $dir_tracked | while read file; do
    
    # Updating percentage bar
    percentage_completion="$((($i * 100) / directory_file_count))"
    progress_bar $percentage_completion

    file_inode=$(stat -c "%i" "$file") # Get inode
    file_name=$(stat --format="%n" "$file") # Get file name
    file_path_absolute=$(readlink -f "$file")  # Get absolute path
    file_type=$(stat --format="%F" "$file")  # Get file type
    file_owner_id=$(stat --format="%u" "$file") # Get file owner ID
    file_group_id=$(stat --format="%g" "$file") # Get group ID
    file_access_priviledges=$(stat --format="%A" "$file") # Get access priviledges
    file_time_last_modified=$(stat --format="%y" "$file") # Get time last modified 
    file_time_last_changed=$(stat --format="%z" "$file") # Get time last changed

    # Create comma seperated string of file attributes
    file_attrs="$file_inode,$file_name,$file_type,$file_path_absolute,$file_owner_id,$file_group_id,$file_access_priviledges,$file_time_last_changed,$file_time_last_modified"

    # If we have a file (not a directory) find its SHA1 and word count
    if [ -f "$file" ]; then
        #Get SHA1 digest of file
        file_digest_sha1=$(openssl dgst -sha1 "$file" | sed 's/^.* //')

        #G
        file_word_count=$(<"$file" wc --words) # Get file word count

        # Append SHA1 of file and word count to the string
        file_attrs="$file_attrs,$file_digest_sha1,$file_word_count"
    fi

    # Write verification state to file
    printf "%s\n" "$file_attrs" >> $write_file

     # Incrememnt progress bar
    i=$((i + 1))
  done

  # Replaced in progress line with complete
  printf "\r\033[K\033[1A\033[K"
  printf "Mapping current state of directory for $1...complete\n\n"

}