#!/bin/bash
# Finds mktemp
import misc/check
import misc/default
import script/cleanup
import script/except
default MKTEMP_INDEX="${$}${RANDOM}0000"

if check_command ; then
	function mktemp {
		local type file

		# Capture?
		if [[ "$capture" ]] ; then
			eval "$capture=\$( type=$type $0 $1 )"
			return $?
		fi

		# Type
		[[ "$type" ]] &&
			type="-$type" ||
			type=$1

		# Exec.
		file=$( $( which mktemp ) $type )
		rtn=$?
		if [[ $rtn -gt 0 ]] ; then
			throw "cant mktemp"
			return $rtn
		fi

		# Report
		echo $file

		# Delete on exit
		cleanup_add "[[ -e $file ]] && rm -rf $file"

		return 0
	}

else
	function mktemp {
		local type

		# Capture?
		if [[ "$capture" ]] ; then
			eval "$capture=\$( type=$type $0 $1 )"
			return $?
		fi

		# Find file name
		MKTEMP_INDEX=$(( $MKTEMP_INDEX + 1 ))
		if [[ -d /tmp ]] ; then
			file="/tmp/kona$MKTEMP_INDEX"
		elif [[ -d /var/tmp ]] ; then
			file="/var/tmp/kona$MKTEMP_INDEX"
		else
			throw "cant mktemp"
			return 2
		fi

		# Error if already exists
		if [[ -e "$file" ]] ; then
			throw "mktemp already exists"
			return 1
		fi

		# Make it
		echo "$file"
		if [[ $type == d ]] || [[ "$1" == "-d" ]] ; then
			mkdir "$file"
		else
			true 1> "$file"
		fi
		rtn=$?
		[[ $rtn -gt 0 ]] &&
			throw "cant mktemp"

		# Delete on exit
		cleanup_add "[[ ! -e $file ]] || rm -rf $file"

		return $rtn
	}

fi


