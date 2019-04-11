#Help function to show how the program should be called
#What options are available for the program and how they should be provided
function get_help(){
    echo "Usage: bash IDS.sh file [options]"$'\n'
    echo "options:"$'\n'
    echo " -c name    Create a verification file called ‘name’ also display a message 'File created'"
    echo " -o name    Display the results on the screen also save the outputs to an output file"
    exit
}

#Gets the commandline argument flags if provided and stored them in flags_set
#and also stores their associated value in flag_vals.
flags_set={}
flag_vals={}

function get_args(){
    flags=0
    for (( i=1; i<=$#; i++)); do
        if [ ${!i} = "-o" ] || [ ${!i} = "-c" ]; then
            flags_set[$flags]=${!i}
            j=$((i+1))
            flas_vals[$flags]=${!j}
            flags=$((flags+1))
        elif [ ${!i} = "--help" ]; then
            get_help
        fi
    done
}
#Check if no arguments are provided
if [ $# -eq 0 ]; then
    get_help
else
    get_args $@
fi

#Prints out command and associated value for testing purposes
for ((i = 0; i < ${#flags_set}; i++)); do
    echo "${flags_set[$i]} ${flags_vals[$i]}"
done