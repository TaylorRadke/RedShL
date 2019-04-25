# TODO: add functions for writing file owner, creator, permissions, last modified, when it was created
#       Hash digest if a file, something about symlinks
#       Create seperate file from the verification file created when -c is used to save states for checking changes 


# Create a verification file if the -c flag is provided.
function create_verification_file {
    if [[ $c_FLAG != "" ]]; then
        verification_file="$(pwd)/tracking/${c_FLAG}.txt"
        touch ${verification_file}
        echo "Verification file Created: $(pwd)/tracking/$c_FLAG.txt"
    else
        verification_file="$(pwd)/tracking/verify.txt"
        touch ${verification_file}
        echo -e "Dev: The below output is only for development purposes and is only being shown because a verification file was not defined with the -c option
         \nVerification file Created: $(pwd)/tracking/verify.txt"
fi
}

#Prints the given symbol(arg 2) the number of times given by arg 1.
function print_symbols {
    for ((i=0; i < $1; i++)); do
        printf "$2" >> $verification_file
    done
}

# Write the table header for the verification file from the input
 function write_file_headers {
   
    # The numbers of characters in the current line being processed from the input file 
    line_length=${#line}

    # Width of the table, long enough that large file paths should not break the table format
    header_length=100

    # Define the start of a new table with input file name in table header
    print_symbols $header_length "="
    printf "\n| $line" >> $verification_file

    print_symbols $((header_length-3-line_length)) " "
    printf "|\n" >> $verification_file

    print_symbols $header_length "="
}


# Write a row to the table which shows the file type of the current line, either file or directory
function write_file_type {
    file=$1
    
    printf "\n| File Type: " >> $verification_file

    # If function arg 1 is file then set file to “file”
    if [ -f $1 ]; then
        type="file"
    # if function arg 1 is directory then set file to “directory”
    elif [ -d $1 ]; then
        type="directory"
    fi

    printf "$type" >> $verification_file
    length=${#type}

    # Print spaces from end of file type to end of row leaving a space for table border.
    print_symbols $((header_length - 14 - length)) " "
    printf "|\n" >> $verification_file
    print_symbols $header_length "-"
}

# Prints the full file path of input line of the given line is a link to a relative file.
function write_full_file_path {
    full_path=$(readlink -f $1)
    printf "\n| Full Path: " >> $verification_file
    printf "$full_path" >> $verification_file
    
    print_symbols $((header_length -14 - ${#full_path})) " "
    printf "|\n" >> $verification_file
    print_symbols $header_length "-"
}

# Save the states of the files from the input file to monitor any changes
function verify_input_file {
    while IFS= read -r line || [ -n "$line" ] ; do
        # If the file exists write a table for it
        if [ -e $line ]; then
            write_file_headers
            write_file_type $line
            write_full_file_path $line
            echo -e "\n" >> $verification_file
        else
            echo "Error: file or directory $line does not exist"
        fi
    done < $file
}
