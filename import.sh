#!/bin/bash
# Import services. 2020 Arctic Kona. No Rights Reserved. NO WARRANTY! https://kona.cf/ mailto:arcticjieer@gmail.com

#
# TODO
# *	Import_get does not work in directories, and is non-recursive

#
# Common variables

# Web location to get shell scripts from
[[ "$IMPORT_URI" ]] ||
	IMPORT_URI="https://shell-scripts.akona.me/"

# Disk location to get shell scripts from
[[ "$IMPORT_ROOT" ]] ||
	IMPORT_ROOT="/tmp/"

# Verbose?
[[ "$IMPORT_VERBOSE" ]] ||
	IMPORT_VERBOSE=0

# Other variables
IMPORT_ALREADY=""
IMPORT_NAME=""
IMPORT_DEPTH=0

# Useful presets
IFS='
'
shopt -s expand_aliases
shopt -s extglob

#
# Fetch package source code
function import_fetch_file {
	local rtn file
	rtn=0

	# Fetch files if there
	if [[ -f "$IMPORT_ROOT/$1" ]] ; then
		cat "$IMPORT_ROOT/$1"
		
	# Or alternative names
	elif [[ -f "$IMPORT_ROOT/$1.sh" ]] ; then
		cat "$IMPORT_ROOT/$1.sh"

	elif [[ -f "$IMPORT_ROOT/$1.bash" ]] ; then
		cat "$IMPORT_ROOT/$1.bash"
		
	# Load all contents if it's a directory
	elif test -d "$IMPORT_ROOT/$1" ; then
		for file in $( ls "$IMPORT_ROOT/$1" ) ; do
			if [[ "${file##*.}" == "" ]] || [[ "${file##*.}" == "sh" ]] || [[ "${file##*.}" == "bash" ]] ; then
				file=${file//\"/\\\"}
				file=${file//\$/\\\$}
				file=${file//\`/\\\`}
				echo "call=public import_file \"$1/$file\""
			fi
		done

	# Fail!
	else
		[[ "$IMPORT_VERBOSE" == "1" ]] &&
			echo "ERROR: CANNOT FIND PACKAGE $1 ON FILESYSTEM" 1>&2
		rtn=$(( $rtn + 1 ))

	fi
	return $rtn
}

function import_fetch_web {
	local rtn file
	rtn=0

	# Download
	if import_webget "$IMPORT_URI/$1" ; then
		true 

	# Alternative names on server?
	elif import_webget "$IMPORT_URI/$1.sh" ; then
		true

	elif import_webget "$IMPORT_URI/$1.bash" ; then
		true

	# So it's a web directory?
	elif import_webget "$IMPORT_URI/$1/index.lst" 1> "$IMPORT_TEMPFILE" ; then
		for file in $( cat "$IMPORT_TEMPFILE" ) ; do
			if [[ "${file##*.}" == "" ]] || [[ "${file##*.}" == "sh" ]] || [[ "${file##*.}" == "bash" ]] ; then
				file=${file//\"/\\\"}
				file=${file//\$/\\\$}
				file=${file//\`/\\\`}
				echo "call=public import_web \"$1/$file\""
			fi
		done

	# Fail!
	else
		[[ "$IMPORT_VERBOSE" == "1" ]] &&
			echo "ERROR: CANNOT FIND PACKAGE $1 CHECK INTERNET" 1>&2
		rtn=$(( $rtn + 1 ))

	fi

	return $rtn
}

function import_fetch {
	local rtn
	rtn=0

	while [[ $# -gt 0 ]] ; do
		import_fetch_file "$1" ||
			import_fetch_web "$1" ||
				rtn=$(( $rtn + 1 ))

		shift
	done
	return $rtn
}

#
# Import package

# Import using suggested fetch command
function import_import {
	local rtn
	rtn=0

	# Error if too deep
	if [[ $IMPORT_DEPTH -gt 32 ]] ; then
		echo "ERROR: IMPORT_DEPTH TOO DEEP"
		exit 255
	fi

	# Load each argument
	while [[ $# -gt 0 ]] ; do
		[[ "$IMPORT_VERBOSE" == "1" ]] &&
			echo "NOTICE: TRYING TO LOAD $1"

		# Continue if already loaded
		if import_check "$1" ; then
			[[ "$IMPORT_VERBOSE" == "1" ]] &&
				echo "NOTICE: $1 ALREADY LOADED, SKIPPING"
			shift
			continue
		fi

		# Fetch
		IMPORT_TEMPFILE=$( $IMPORT_FETCH_COMMAND "$1" )
		if [[ $? -gt 0 ]] ; then
			echo "WARNING: CANNOT FIND PACKAGE $1" 1>&2
			rtn=$(( $rtn + 1 ))
			shift
			continue
		fi

		# Record (even failed attempts)
		IMPORT_ALREADY="$IMPORT_ALREADY
$1"

		# Load
		function import_tempfile {
			local IMPORT_DEPTH=$(( $IMPORT_DEPTH + 1 ))
			eval "$IMPORT_TEMPFILE"
			return $?
		}
		import_tempfile

		# Check errors
		if [[ $? -gt 0 ]] ; then
			echo "WARNING: $1 RETURNED NON-ZERO EXIT CODE" 1>&2
			rtn=$(( $rtn + 1 ))
		elif [[ "$IMPORT_VERBOSE" == "1" ]] ; then
				echo "NOTICE: $1 LOADED OKAY"
		fi

		shift
	done

	return $rtn
}

# Just from disk
function import_file {
	local IFS=
	IMPORT_FETCH_COMMAND=import_fetch_file import_import $@
}

# Just from web
function import_web {
	local IFS=
	IMPORT_FETCH_COMMAND=import_fetch_web import_import $@
}
# Use both
function import {
	local IFS=
	IMPORT_FETCH_COMMAND=import_fetch import_import $@
}
#
# Download package to IMPORT_ROOT
function import_get {
	local rtn
	rtn=0

	while [[ $# -gt 0 ]] ; do
		# Check overwrite
		[[ "$IMPORT_VERBOSE" == "1" ]] && [[ -f "${IMPORT_ROOT}/$1" ]] &&
			echo "WARNING: OVERWRITTING $1" 1>&2

		# Make directory
		local dir base
		dir="${IMPORT_ROOT}/$1"
		base=${dir##*/}
		mkdir -p "${dir%$base}"

		# Fetch
		import_fetch_web "$1" 1> "${IMPORT_ROOT}/$1"
		if [[ $? -gt 0 ]]  ; then
			[[ "$IMPORT_VERBOSE" == "1" ]] &&
				echo "ERROR: FETCH RETURNED NON-ZERO ERROR STATUS" 1>&2
			[[ -f "${IMPORT_ROOT}/$1" ]] &&
				rm "${IMPORT_ROOT}/$1" 2> /dev/null
			rtn=$(( $rtn + 1 ))
		fi

		shift
	done
	return $rtn
}

# TODO: implement deletion of local packages

#
# Find download program

# Is there wget?
if which wget 1> /dev/null ; then
	function import_webget {
		wget -qO - "$1"
		return $?
	}

# Is there curl?
elif which curl 1> /dev/null ; then
	function import_webget {
		curl "$1"
		return $?
	}

# Are we stuck with ncat?
elif which ncat 1> /dev/null ; then
	# Bare (does not work)
	function import_webget {
		host=$( echo "$1" | cut -d "/" -f 3 - )
		path=$( echo "$1" | cut -d "/" -f 4- - )
		printf "GET /$path HTTP/1.0\r\nHost: $host\r\nUser-Agent: import_webget\r\nConnection: close\r\n\r\n" | \
		ncat -w 4 --ssl $host 443 | \
		grep -x -F -A 1073741824 -e "" - 
		return 0
	}

# Or nothing
else
	echo "wget or curl required" 1>&2
	exit 3

fi

#
# Find checking program

# Grep?
if which grep 1> /dev/null ; then
	function import_check {
		echo "$IMPORT_ALREADY" | grep -xqFe "$1" - 
		return $?
	}

# Use shell buitins only
else
	function import_check {
		local line IFS
		IFS="
"
		for line in $IMPORT_ALREADY ; do
			[[ "$line" == "$1" ]] &&
				return 0
		done
		return 1
	}

fi



