#!/bin/bash
# Runs in a temporary directory

function runonline {
	local file path IFS=""
	file=$( import_mktemp -d )
	path=$( pwd )
	cd "$file" ||
		return $?

	# Function for local variables
	function runonline_runonline {
		local file IFS=""
		$@
		return $?
	}

	runonline_runonline $@

	cd "$path"
	return $?
}


