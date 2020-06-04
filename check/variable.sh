#!/bin/bash
# Simple checking functions. 2019 Arctic Kona. No rights reserved.

# Returns to caller $? if $? is not zero
alias check_return="CHECK_RETURN=\$? ; test \$CHECK_RETURN == 0 || return \$CHECK_RETURN ; true"

# Returns true if argument is empty, 0, or "false"
function check_true {
	if [[ "$1" == "" ]] || [[ "$1" == 0 ]] || [[ "$1" == "false" ]] || [[ "$1" == "False" ]] || [[ "$1" == "FALSE" ]] ; then
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
		grep -qxEe "-?[0-9]+(\.[0-9]+)?" - <<< "$1" ||
			rtn=$(( $rtn + 1 ))
		shift
	done
	return $rtn
}


