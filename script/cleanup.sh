#!/bin/bash
# Executes commands before script exits
import log/log

# The function
function cleanup {
	local exec
	# If add stuff
	if [[ $exec$1 ]] ; then
		exec=$exec cleanup_add $1
		return $?
	fi

	# Or run commands
	local IFS=$( printf "\\30" )
	for exec in $CLEANUP_LIST ; do
		eval "$exec" ||
			log_warn "\"$exec\" returned $?"
	done

	return 0
}

# Add commands
function cleanup_add {
	local IFS=$( printf "\\30" )
	CLEANUP_LIST="$CLEANUP_LIST$IFS$1$IFS$@"
	return 0
}

# Binds
function exec {
	local IFS=""
	$@
	exit $?
}
trap "cleanup;exit" SIGINT
trap "cleanup;exit" SIGTERM
trap cleanup EXIT

