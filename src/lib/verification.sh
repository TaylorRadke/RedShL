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
  tracking_files=$(find $dir_tracked)

  for file in $tracking_files; do
    file_path_absolute=$(readlink -f $file)
    file_type=$(stat -c "%F" $file)

  done
}
