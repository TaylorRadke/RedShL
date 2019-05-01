#Verification Source for file verification
create_verification_file() {
    #remove any verification file with same name if they exist
    if [ -e ${verification_file} ]; then
      rm ${verification_file}
    fi
    touch ${verification_file}
    printf "Verification file Created: %s\n\n" "${verification_file}"
}

progress_bar(){
  j=0
  percent_steps=4 #Set when to update the proress bar, e.g every 5%
  percent_padding=$((100/percent_steps)) #Padding for progress bar between bar based on percent steps
  percent_string=""

  while [ $j -le $1 ]
  do
    if [ $((j % percent_steps)) -eq 0 ]
    then
      percent_string="$percent_string#"
    fi
    j=$((j + 1))
  done
  printf "\r[%-${percent_padding}s] (%d%%)" "$percent_string" "$1"

}
# Get the current state of the dir_tracked directory by storing attributes of its contents
create_verification_state() {
  write_file=$1
  if [ -e $write_file ]; then
    rm $write_file
    touch $write_file
  fi
  directory_file_count=$(find $dir_tracked | wc -l)

  printf "\n"
  i=1
  percent_string=""
  find $dir_tracked | while read file; do

    percentage_completion="$((($i * 100) / directory_file_count))"
    progress_bar $percentage_completion


    file_inode=$(stat -c "%i" "$file")
    file_name=$(stat --format="%n" "$file")

    file_path_absolute=$(readlink -f "$file")
    file_type=$(stat --format="%F" "$file")

    file_owner_id=$(stat --format="%u" "$file")
    file_group_id=$(stat --format="%g" "$file")
    file_access_priviledges=$(stat --format="%A" "$file")

    #Gets the milliseconds since 01-1-1970 (epoch timestamp)
    file_time_last_modified=$(stat --format="%Y" "$file")
    file_time_last_changed=$(stat --format="%Z" "$file")

    #Create comma delimted string of file attributes
    file_attrs="$file_inode,$file_name,$file_type,$file_path_absolute,$file_owner_id,$file_group_id,$file_access_priviledges,$file_time_last_changed,$file_time_last_modified"

    if [ -f "$file" ]; then
        #Get sha1 and md5 digests
        file_digest_sha1=$(openssl dgst -sha1 "$file" | sed 's/^.* //')

        #Get file word count
        file_word_count=$(<"$file" wc --words)

        #Append file digest and word count to file attrs string
        file_attrs="$file_attrs,$file_digest_sha1,$file_word_count"
    fi
    #Write verification state to file
    printf "%s\n" "$file_attrs" >> $write_file
    i=$((i + 1))
  done
}
