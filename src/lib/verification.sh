
function create_verification_file {
    if [ $c_FLAG != "" ]; then
        verification_file="$(pwd)/tracking/${c_FLAG}.txt"
        touch ${verification_file}
        echo "Verification file Created: $(pwd)/tracking/$c_FLAG.txt"
fi
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
    file=$1
    type=$(file -bpN $file)
    
    printf "\n| File Type: " >> $verification_file
    if [ -f $1 ]; then
        type="file"
    elif [ -d $1 ]; then
        type="directory"
    fi

    printf "$type" >> $verification_file
    length=${#type}
    print_symbols $((header_length - 14 - length)) " "
    printf "|\n" >> $verification_file
    print_symbols $header_length "-"
}

function write_full_file_path {
    full_path=$(readlink -f $1)
    printf "\n| Full Path: " >> $verification_file
    printf "$full_path" >> $verification_file
    
    print_symbols $((header_length -14 - ${#full_path})) " "
    printf "|\n" >> $verification_file
    print_symbols $header_length "-"
}

function verify_input_file {
    while IFS= read -r line || [ -n "$line" ] ; do
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