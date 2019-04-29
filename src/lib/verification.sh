#Verification Source for file verification

# Create a verification file if the -c flag is provided.
function create_verification_file {
    verification_file="$(pwd)/tracking/${c_FLAG}"
    touch ${verification_file}
    echo "Verification file Created: $(pwd)/tracking/$c_FLAG"
}

#Get the current state of the dir_tracked directory by storing attributes
#of its contents
function create_verification_state {
  tracking_files=($(find $dir_tracked))
  echo ${#tracking_files[@]}
  #printf "Tracking %d files\n" "${#tracking_files}"

  for file in $tracking_files; do
    #Recreate file_attrs array
    file_attrs=()

    #Get all file attributes
    file_inode=$(stat --format="%i" $file)
    file_name=$(stat --format="%n" $file)
    file_path_absolute=$(readlink -f $file)
    file_type=$(stat --format="%F" $file)
    file_owner_id=$(stat --format="%u" $file)
    file_group_id=$(stat --format="%g" $file)
    file_access_priviledges=$(stat --format="%A" $file)
    file_time_last_modified=$(stat --format="%y" $file)
    file_time_last_accessed=$(stat --format="%x" $file)

    #Add all attrs to array for both files and directories
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
      file_word_count=$(wc --chars $file)

      #Add digest and word count to file_attrs array
      file_attrs=("${file_attrs[@]}" $file_digest_md5 $file_digest_sha1 $file_word_count)
    fi
  done
}
