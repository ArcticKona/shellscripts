#!/bin/bash
# Simple checking functions. 2019 Arctic Kona. No rights reserved.
import misc/tocase

# Returns to caller $? if $? is not zero
alias check_return="check_rtnc=\$? ; test \$check_rtnc == 0 || return \$check_rtnc ; true"

# Returns false if argument is empty
function check_empty {
	test "$@" != ""
	return $?
}

# Returns number of commands that are missing
function check_command {
	local rtn=0
	while [[ $# -gt 0 ]] ; do
		command -v "$1" 1> /dev/null ||
			rtn=$(( rtn + 1 ))
		shift
	done
	return $rtn
}

# Returns true if argument is empty, 0, or "false"
function check_true {
	if [[ "$1" == "" ||
	"$1" == 0 ||
	$( tocase_lower "$1" ) == "false" ]] ; then
		[[ "$2" == "" ]] &&
			return 1 ||
			return $2
	fi
	return 0
}

# Returns false if argument is not empty, 0, or "false"
function check_false {
	if check_true "$1" ; then
		[[ "$2" == "" ]] &&
			return 1 ||
			return $2
	fi
	return 0
}

# Checks if it looks like a number
function check_number {
	rtn=0
	while [[ $# -gt 0 ]] ; do
		grep -qxEe "-?[0-9]+(\.[0-9]+)?" - <<< "$1" &&
			rtn=$(( $rtn + 1 ))
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

