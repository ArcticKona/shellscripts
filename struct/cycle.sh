#!/bin/bash
# Tries each command until first error.
import misc/default
default	CYCLE_SELF=CYCLE	# TODO: OOP shell scripts?
default CYCLE_SEPARATOR=$( printf "\\31" )

function cycle_add {
	while [[ $# -gt 0 ]] ; do
		eval "${CYCLE_SELF}_LIST=\"\$${CYCLE_SELF}_LIST${CYCLE_SEPARATOR}$1\""
		shift
	done
	return 0
}

function cycle_delete {
	local IFS="$CYCLE_SEPARATOR"
	local temp

	while [[ $# -gt 0 ]] ; do
		for exec in $( eval "echo \"\$${CYCLE_SELF}_LIST\"" ) ; do
			[[ "$1" == "$exec" ]] ||
				temp="${temp}$CYCLE_SEPARATOR$1"
		done

		eval "${CYCLE_SELF}_LIST=\"\$temp\""
		shift
	done

	return 0
}

function cycle_cycle {
	local IFS="$CYCLE_SEPARATOR"

	for exec in $( eval "echo \"\$${CYCLE_SELF}_LIST\"" ) ; do
		[[ "$exec" ]] ||
			continue

		eval "$exec"
		rtn=$?

		[[ $rtn -gt 0 ]] &&
			return $rtn

	done
	return 0
}

function cycle_new {
	local capture
	default capture="$1"

	alias "${capture}_add=CYCLE_SELF=$capture cycle_add"
	alias "${capture}_delete=CYCLE_SELF=$capture cycle_delete"
	alias "${capture}=CYCLE_SELF=$capture cycle_cycle"

	return 0
}

