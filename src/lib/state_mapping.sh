#Verification Source for file verification
function create_verification_file {
    #remove any verification file with same name if they exist
    if [ -e ${verification_file} ]; then
      rm ${verification_file}
    fi
    touch ${verification_file}
    printf "Verification file Created: %s\n\n" "${verification_file}"
}


function map_initial_directory_state {
  #Save the current state of the given directory for verification
  create_verification_state
  #copy file_map to initial_state_map
  for key in "${!file_map[@]}"; do
    initial_state_map[$key]="${file_map[$key]}"
    if [ $c_flag_set = true ]; then
      printf "%s\n" "${initial_state_map[$key]}" >> $verification_file
    fi
  done
}

#Get the current state of the dir_tracked directory by storing attributes
#of its contents
function create_verification_state {
  tracking_files=$(find $dir_tracked)

  for file in $tracking_files; do
    #Get all file attributes

    file_inode=$(stat --format="%i" $file)
    dir_inodes=(${dir_inodes[@]} $file_inode)

    file_name=$(stat --format="%n" $file)
    file_path_absolute=$(readlink -f $file)
    file_type=$(stat --format="%F" $file)
    file_owner_id=$(stat --format="%u" $file)
    file_group_id=$(stat --format="%g" $file)
    file_access_priviledges=$(stat --format="%A" $file)
    file_time_last_modified=$(stat --format="%y" $file)
    file_time_last_accessed=$(stat --format="%x" $file)

    #Add all attrs to string
    file_attrs=(
      $file_inode
      $file_name
      $file_path_absolute
      $file_owner_id
      $file_group_id
      $file_access_priviledges
      $file_time_last_accessed
      $file_time_last_modified
    )

    #Check if file is a regular file
    if [ -f $file ]; then
      #Get sha1 and md5 digests
      file_digest_sha1=$(openssl dgst -sha1 $file | sed 's/^.* //')
      file_digest_md5=$(openssl dgst -md5 $file | sed 's/^.* //')

      #Get file word count
      file_word_count=$(<$file wc --words)

      #Add digests and word count to file_attrs array
      file_attrs=( ${file_attrs[@]} ${file_digest_md5} ${file_digest_sha1} ${file_word_count} )
    fi

    map_string=$( IFS=","; echo "${file_attrs[*]}")
    file_map[${file_inode}]=${map_string}
  done
}
