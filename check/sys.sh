#!/bin/bash
# Simple checking functions. 2019 Arctic Kona. No rights reserved.

# Returns number of commands that are missing
function check_command {
	local echo
	check_true "$echo" &&
		echo=true ||
		echo=""
	
	local rtn=0
	while [[ $# -gt 0 ]] ; do
		if ! command -v "$1" 1> /dev/null ; then
			[[ "$echo" ]] &&
				echo "$1"
			rtn=$(( rtn + 1 ))
		fi
		shift
	done
	return $rtn
}

# Checks if shell support arrays
CHECK_ARRAY[1]="YES" 2> /dev/null
function check_array {
	[[ ${CHECK_ARRAY[1]} == "YES" ]] 2> /dev/null
	return $?
}


