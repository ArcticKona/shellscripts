#!/bin/bash
# Imports shell subs. 2019 Arctic Kona. No rights reserved.
test "$IMPORT_DIR" == "" &&	# Root directory to import stuff from
	IMPORT_DIR="`pwd`/"
test "$IMPORT_URI" == "" &&	# URI to download scripts from
	IMPORT_URI="https://shell-scripts.akona.me/"
IMPORT_ALREADY=""		# subs already considered loaded

# Useful presets
IFS='
'
shopt -s expand_aliases

# Tests if required commands are here
for i in wget realpath grep ; do
	if ! which $i 1>/dev/null ; then
		printf "ERROR: COMMAND $i NOT FOUND \r\n"
		return 1
	fi
done

# Import
function import {
	IFS='
'
	local rtn=0
	local load_file=$( mktemp ) ||
		return $?

	while test $# -gt 0 ; do
		# Is it already loaded?
		local real_path=$( realpath "$IMPORT_DIR/$1" )
		if echo "$IMPORT_ALREADY" | grep -qxFe "$real_path" - ; then
			shift
			continue
		fi
		IMPORT_ALREADY=$( printf "%s\n%s" "$real_path" "$IMPORT_ALREADY" )	# Record failures too

		# Load files if there
		if test -f "$real_path" ; then
			import_source "$real_path"
			rtn=$(( $rtn + $? ))

		# Or alternative name
		elif test -f "$real_path.sh" ; then
			import_source "$real_path.sh"
			rtn=$(( $rtn + $? ))

		# Load all contents if it's a directories
		elif test -d "$real_path" ; then
			for file in $( ls "$real_path" ) ; do
				import "$real_path/$file"
				rtn=$(( $rtn + $? ))
			done

		# Or download
		elif wget -qO "$load_file" "$IMPORT_URI/$1" ; then
			import_source "$load_file"
			rtn=$(( $rtn + $? ))

		# Alternative name on server?
		elif wget -qO "$load_file" "$IMPORT_URI/$1.sh" ; then
			import_source "$load_file"
			rtn=$(( $rtn + $? ))

		# So it's a web directory?
		elif wget -qO "$load_file" "$IMPORT_URI/$1/index.lst" ; then
			for file in $( cat "$load_file" ) ; do
				import "${1}/${file}"
				rtn=$(( $rtn + $? ))
			done

		# Oops ...
		else
			printf "CANNOT FIND $1 CHECK FILESYSTEM OR INTERNET SERVICE \r\n" 1>&2
			rtn=$(( $rtn + 1 ))

		fi

		shift
	done

	rm "$load_file"
	unset IFS
	return $rtn
}

# Import just a file
function import_source {
	source "$1"
	if test $? -gt 0 ; then
		test "$2" != "" &&
			printf "$2 RETURNED A NON-ZERO EXIT CODE \r\n" 1>&2 ||
			printf "$1 RETURNED A NON-ZERO EXIT CODE \r\n" 1>&2
		return 1
	fi
	return 0
}

# Alias
function import_import {
	import "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
	return $?
}

