# TODO: add functions for writing file owner, creator, permissions, last modified, when it was created
#       Hash digest if a file, something about symlinks
#       Create seperate file from the verification file created when -c is used to save states for checking changes


# Create a verification file if the -c flag is provided.
function create_verification_file {
    verification_file="$(pwd)/tracking/${c_FLAG}"
    touch ${verification_file}
    echo "Verification file Created: $(pwd)/tracking/$c_FLAG"
}

# Save the states of the files from the input file to monitor any changes
function verify_input_file {
    #Read all lines from input file
    while IFS= read -r file || [ -n "$file" ] ; do
        if [ -e $file ]; then
            file_type=$(stat -c "%F" $file)
            file_path_absolute=$(readlink -f $file)

            if [ $c_flag_set = true ]; then
                write_file_header
                write_file_type
                write_file_path_absolute
                echo -e "\n" >> $verification_file
            fi
        fi
    done < $file_list
}
