if [[ $c_FLAG != "" ]]; then
    verification_file="$(pwd)/tracking/${c_FLAG}.txt"
    touch ${verification_file}
    echo "Verification file Created: $(pwd)/tracking/$c_FLAG.txt"
else
    verification_file="$(pwd)/tracking/verify.txt"
    touch ${verification_file}
    echo "Dev: Verification file Created: $(pwd)/tracking/verify.txt"
fi

function print_symbols_to_verification_file {
    for ((i=0; i < $1; i++)); do
        printf "$2" >> $verification_file
    done
}

function verify_input_file {
    while IFS= read -r line || [ -n "$line" ] ; do
        line_length=${#line}
        symbols_length=60

        print_symbols_to_verification_file $symbols_length "-"
        printf "\n| $line" >> $verification_file

        print_symbols_to_verification_file $((symbols_length-3-line_length)) " "
        printf "|\n" >> $verification_file

        print_symbols_to_verification_file $symbols_length "-"
        echo -e "\n" >> $verification_file
    done < $file
}