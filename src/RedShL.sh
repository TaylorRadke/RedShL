#!/bin/bash

#Import functions from lib/
source lib/flags.sh

#Get help if no arguments are provided
[ $# -eq 0 ] && { get_help; }

#Get help if help arg provided
help_arg_provided $@

#get arg
parse_args $@