
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

function print_symbols {
    for ((i=0; i < $1; i++)); do
        printf "$2" >> $verification_file
    done
}

 function write_verification_file_headers {
    line_length=${#line}
    header_length=60

    print_symbols $header_length "="
    printf "\n| $line" >> $verification_file

    print_symbols $((header_length-3-line_length)) " "
    printf "|\n" >> $verification_file

    print_symbols $header_length "-"
    echo -e "\n" >> $verification_file
}

function verify_input_file {
    while IFS= read -r line || [ -n "$line" ] ; do
       write_verification_file_headers

       echo -e "\n" >> $verification_file
    done < $file
}