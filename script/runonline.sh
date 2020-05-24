#!/bin/bash
# Runs in a temporary directory

function runonline {
	local RUNONLINE_FILE RUNONLINE_PATH IFS=""
	RUNONLINE_FILE=$( mktemp -d )
	RUNONLINE_PATH=$( pwd )
	cd "$RUNONLINE_FILE" ||
		return $?

	# Function for local variables
	function runonline_runonline {
		local RUNONLINE_FILE RUNONLINE_PATH IFS=""
		alias exec=""	# Make sure we dont quit
		alias exit="true"
		$@
		return $?
	}

	runonline_runonline $@

	rm -rf "$RUNONLINE_FILE"
	cd "$RUNONLINE_PATH"
	return $?
}


