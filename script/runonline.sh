#!/bin/bash
# Runs in a temporary directory
import misc/check
import system/mktemp

# Execute command in temporary directory
function runonline {
	local exec
	runonline_enter ||
		return $?

	if [[ $# -gt 0 ]] ; then
		( $@ )
	elif [[ $exec ]] ; then
		( eval "$exec" )
	else
		return 0
	fi

	runonline_leave
	return $?
}

# Or, execute rest of script in temporary directory
function runonline_enter {
	local root path
	path=$( pwd )
	root=$( mktemp -d ) ||
		return $?
	cd "$root" ||
		return $?
	RUNONLINE_ROOT="$RUNONLINE_ROOT|$root|$path"
	cleanup_add "[[ ! -e $root ]] || rm -rf $root"
	return 0
}

# Use this on leave
function runonline_leave {
	[[ ${RUNONLINE_ROOT##*|} ]] &&
		cd ${RUNONLINE_ROOT##*|}
	RUNONLINE_ROOT=${RUNONLINE_ROOT%|*}
	[[ ${RUNONLINE_ROOT##*|} ]] &&
		rm -rf ${RUNONLINE_ROOT##*|}
	rtn=$?
	RUNONLINE_ROOT=${RUNONLINE_ROOT%|*}
	return $rtn
}


