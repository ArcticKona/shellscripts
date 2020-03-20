#!/bin/bash
import log/log
import misc/default

# Gets the legnth of a string
function length_length {
	[[ "$2" != "" ]] &&
		eval $2=${#1} ||
		echo ${#1}

	return $?
}

# Finds the shortest string
function length_shortest {
	local length string
	local IFS="
"

	# If arguments
	if [[ $# -gt 0 ]] ; then
		LENGTH_SHORTEST="$1"
		length=${#LENGTH_SHORTEST}
		shift
		while [[ $# -gt 0 ]] ; do
			if [[ $length -gt ${#1} ]] ; then
				LENGTH_SHORTEST="$1"
				length=${#LENGTH_SHORTEST}

			fi
			shift

		done

	# Else use STDIN
	else
		LENGTH_SHORTEST=$( head -n 1 - ) ||
			return $?
		length=${#LENGTH_SHORTEST}
		for string in $( cat - ) ; do
			if [[ $length -gt ${#string} ]] ; then
				LENGTH_SHORTEST="$string"
				length=${#LENGTH_SHORTEST}

			fi

		done

	fi

	# Exit
	echo "$LENGTH_SHORTEST"
	return 0
}

# Find the longest string
function length_longest {
	local length string
	local IFS="
"

	# If arguments
	if [[ $# -gt 0 ]] ; then
		LENGTH_LONGEST="$1"
		length=${#LENGTH_LONGEST}
		shift
		while [[ $# -gt 0 ]] ; do
			if [[ $length -lt ${#1} ]] ; then
				LENGTH_LONGEST="$1"
				length=${#LENGTH_LONGEST}

			fi
			shift

		done

	# Else use STDIN
	else
		LENGTH_LONGEST=$( head -n 1 - ) ||
			return $?
		length=${#LENGTH_LONGEST}
		for string in $( cat - ) ; do
			if [[ $length -lt ${#string} ]] ; then
				LENGTH_LONGEST="$string"
				length=${#LENGTH_LONGEST}

			fi

		done

	fi

	# Exit
	echo "$LENGTH_LONGEST"
	return 0
}


