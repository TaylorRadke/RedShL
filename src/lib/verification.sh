# TODO: add functions for writing file owner, creator, permissions, last modified, when it was created
#       Hash digest if a file, something about symlinks
#       Create seperate file from the verification file created when -c is used to save states for checking changes


# Create a verification file if the -c flag is provided.
function create_verification_file {
    verification_file="$(pwd)/tracking/${c_FLAG}"
    touch ${verification_file}
    echo "Verification file Created: $(pwd)/tracking/$c_FLAG"
}


#Get the current state of the dir_tracked directory by storing attributes
#of its contents

function create_verification_state {
  #Gets all files, directorys and symbolic links in the given directory
  #and using grep to remove labels for folders from using ls -R
  rm verification_file
  touch verification_file

  tracking_files=$(find $dir_tracked)

  for file in $tracking_files; do
    file_inode=$(stat --format="%i" $file)
    file_name=$(stat --format="%n" $file)
    file_path_absolute=$(readlink -f $file)
    file_type=$(stat --format="%F" $file)
    file_owner_id=$(stat --format="%u" $file)
    file_group_id=$(stat --format="%g" $file)
    file_access_priviledges=$(stat --format="%A" $file)
    file_time_last_modified=$(stat --format="%y" $file)
    file_time_last_accessed=$(stat --format="%x" $file)

    printf "$file_inode," >> verification_file
    printf "$file_path_absolute," >> verification_file
    printf "$file_name," >> verification_file
    printf "$file_type," >> verification_file
    printf "$file_owner_id," >> verification_file
    printf "$file_group_id," >> verification_file
    echo -n "$file_access_priviledges," >> verification_file
    printf "$file_time_last_modified," >> verification_file
    printf "$file_time_last_accessed" >> verification_file
    printf "\n" >> verification_file
  done
}
