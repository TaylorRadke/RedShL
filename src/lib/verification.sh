
function create_verification_file {
    verification_file="$(pwd)/tracking/${c_FLAG}.txt"
    touch ${verification_file}
    echo "Verification file Created: $(pwd)/tracking/$c_FLAG.txt"
}

function print_symbols {
    for ((i=0; i < $1; i++)); do
        printf "$2" >> $verification_file
    done
}

 function write_file_headers {
    line_length=${#line}
    header_length=100

    print_symbols $header_length "="
    printf "\n| $line" >> $verification_file

    print_symbols $((header_length-3-line_length)) " "
    printf "|\n" >> $verification_file

    print_symbols $header_length "="
}

function write_file_type {
    printf "$type" >> $verification_file
    length=${#type}
    print_symbols $((header_length - 14 - length)) " "
    printf "|\n" >> $verification_file
    print_symbols $header_length "-"
}

function write_full_file_path {
    printf "\n| Full Path: " >> $verification_file
    printf "$full_path" >> $verification_file
    
    print_symbols $((header_length -14 - ${#full_path})) " "
    printf "|\n" >> $verification_file
    print_symbols $header_length "-"
}

function verify_input_file {
    while IFS= read -r file || [ -n "$file" ] ; do 
        if [ -e $file ]; then
            file_type=$(stat -c "%F" $file)
            echo $file_type

            full_file_path=$(readlink -f $file)
            echo $full_file_path
            # if [ $c_flag_set = true ]; then
            #     write_file_headers
            #     write_file_type
            #     write_full_file_path
            #     echo -e "\n" >> $verification_file
            # fi
        fi
    done < $file_list
}