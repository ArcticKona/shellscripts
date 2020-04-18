#!/bin/bash
# Very basic OOP for bash. 2020 Arctic Kona. No rights reserved.
import misc/argument
import misc/check
import log/log

# Creates a new struct
function struct_new {
	local IFS='
'

	[[ "$2" ]] ||
		log_err "not enough arguments"
	local property method

	# It should have at least a property or method
	if [[ $( eval "echo \$$1_PROPERTY\$$1_METHOD" ) == "" ]] ; then
		log_warn "are you sure $1 is a class?"
	fi

	# For each property
	for property in $( eval "echo \$$1_PROPERTY" ) ; do
		eval "$2_$property=\"\$$1_$property\""
	done

	# For each method
	for method in $( eval "echo \$$1_METHOD" ) ; do
		alias $2_$method="STRUCT_SELF=\"$2\" $1_$method"
	done

	# Copy specials
	eval "$2_PROPERTY=\"\$$1_PROPERTY\""
	eval "$2_METHOD=\"\$$1_METHOD\""
	check_command $1_INIT &&
		alias $2_INIT="STRUCT_SELF=\"$2\" $1_INIT"

	# Execute init
	check_command $1_INIT &&
		STRUCT_SELF="$2" $1_INIT "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}" "${10}" "${11}" "${12}" "${13}" "${14}" "${15}" "${16}" "${17}" "${18}"

	return 0
}

# Initializes the "SELF" variables. Explicit calls are more performance friendly
function struct_enter {
	while [[ $# > 0 ]] ; do
		eval "SELF_$1=\"\$${STRUCT_SELF}_$1\""
		shift
	done

	return 0
}

# Same as above, but reversed
function struct_leave {
	while [[ $# > 0 ]] ; do
		eval "${STRUCT_SELF}_$1=\"\$SELF_$1\""
		shift
	done

	return 0
}


