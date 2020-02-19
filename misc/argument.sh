#!/bin/bash
# Loads arguments python style into variables. 2020 Arctic Kona. No rights reserved.
import misc/default
default ARGUMENT_PREFIX="ARG_"

# Loads arguments
alias argument='
	ARGUMENT_INDEX=0

	while [[ $# -gt 0 ]] ; do
		# Get and escape pairs.
		ARGUMENT_KEY=$( echo "$1" | cut -d = -s -f 1 )
		ARGUMENT_VALUE=$( echo "$1" | cut -d = -f 2- - )

		ARGUMENT_VALUE=${ARGUMENT_VALUE//\"/\\\"}
		ARGUMENT_VALUE=${ARGUMENT_VALUE//\$/\\\$}
		ARGUMENT_VALUE=${ARGUMENT_VALUE//\`/\\\`}

		# Assign for key, or index otherwise
		if [[ "$ARGUMENT_KEY" ]] ; then
			eval "local ${ARGUMENT_PREFIX}${ARGUMENT_KEY}=\"$ARGUMENT_VALUE\""
		else
			eval "local ${ARGUMENT_PREFIX}${ARGUMENT_INDEX}=\"$ARGUMENT_VALUE\""
			ARGUMENT_INDEX=$(( ARGUMENT_INDEX + 1 ))
		fi

		shift
	done
'

# DEBUG: Simple tester
function argument_test {
	argument_load
	echo "$ARG_0 $ARG_test $ARG_1"
}


