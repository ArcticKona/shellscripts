#!/bin/bash
# Assigns variables it doesn't exist or is empty. 2020 Arctic Kona. No rights reserved.

function default {
	while [[ $# -gt 0 ]] ; do
		local default_key=$( echo "$1" | cut -d = -f 1 )
		local default_value=$( echo "$1" | cut -d = -f 2- )

		default_value=${default_value//\"/\\\"}
		default_value=${default_value//\$/\\\$}
		default_value=${default_value//\`/\\\`}

		if [[ "$default_key" && $( eval "echo \$$default_key" ) == "" ]] ; then
			eval "$default_key=\"$default_value\""
		fi

		shift
	done
	return 0
}

alias default_global=default

# TODO: Like above, but make local variables

alias default_local='
	import log/log
	log_err "default_local not implemented"
'

