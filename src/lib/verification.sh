# TODO: add functions for writing file owner, creator, permissions, last modified, when it was created
#       Hash digest if a file, something about symlinks
#       Create seperate file from the verification file created when -c is used to save states for checking changes 


# Create a verification file if the -c flag is provided.
function create_verification_file {
    verification_file="$(pwd)/tracking/${c_FLAG}"
    touch ${verification_file}
    echo "Verification file Created: $(pwd)/tracking/$c_FLAG"
}

#Prints the given symbol(arg 2) the number of times given by arg 1.
function print_symbols {
    for ((i=0; i < $1; i++)); do
        printf "$2" >> $verification_file
    done
}

function write_file_header {
    line_length=${#file}
    header_length=100

    print_symbols $header_length "="
    header=""

    print_symbols $((header_length)) " "
    printf "|\n" >> $verification_file

    print_symbols $header_length "="
    printf "\n" >> $verification_file
}


# Write a row to the table which shows the file type of the current line, either file or directory
function write_file_type {
    row="| File Type: $file_type"

    #Length of row needed to know how many spaces to print
    row_length=$((${#row}+1))
    
    printf "${row}" >> $verification_file

    print_symbols $((header_length - row_length)) " "

    printf "|\n" >> $verification_file

    print_symbols $header_length "-"
    printf "\n" >> $verification_file
}

# Prints the full file path of input line of the given line is a link to a relative file.
function write_file_path_absolute {
    row="| Absolute Path: $file_path_absolute"
    row_length=$((${#row}+1))

    printf "${row}" >> $verification_file

    print_symbols $((header_length - row_length)) " "
    
    printf "|\n" >> $verification_file

    print_symbols $header_length "-"
    printf "\n" >> $verification_file

}

# Save the states of the files from the input file to monitor any changes
function verify_input_file {
    #Read all lines from input file
    while IFS= read -r file || [ -n "$file" ] ; do 
        if [ -e $file ]; then
            file_type=$(stat -c "%F" $file)
            file_path_absolute=$(readlink -f $file)

            echo $file_path_absolute
            if [ $c_flag_set = true ]; then
                write_file_header
                write_file_type
                write_file_path_absolute
                echo -e "\n" >> $verification_file
            fi
        fi
    done < $file_list
}
