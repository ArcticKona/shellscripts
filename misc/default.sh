#!/bin/bash
# Assigns variables it doesn't exist or is empty. 2020 Arctic Kona. No rights reserved.

function default {
	local rtn=0

	while [[ $# -gt 0 ]] ; do
		local default_key=${1%%=*}
		local default_value=${1#*=}

		default_value=${default_value//\"/\\\"}
		default_value=${default_value//\$/\\\$}
		default_value=${default_value//\`/\\\`}

		if [[ $( eval "echo \$$default_key" ) == "" ]] ; then
			eval "$default_key=\"$default_value\""
		else
			rtn=$(( rtn + 1 ))
		fi

		shift
	done

	return $rtn	# Returns number of matches
}


