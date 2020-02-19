#!/bin/bash
# Netlify build script
IFS="
"
# Makes index
function index {
	test "$1" == "" &&
		return 10

	test -d "$1" ||
		return 0

	local pwd=$( pwd )
	cd "$1"

	for file in $( ls ) ; do
		index "$file"
	done
	ls 1> index.lst

	cd "$pwd"
	return 0
}
index . ||
	exit $?

# Create version 0 directory
mkdir v0 ||
	exit $?
cp -r * v0

exit 0

