#!/bin/bash
# Tries to unzip stdin FIXME: buggy and untested
# TODO: exclude files
# alternative error handling?
import check/system
import log/log
import script/except
import system/cat
import system/mktemp
UNZIP_TEMPFILE=

# Magic numbers
UNPACK_pkzip1=$( printf 'PK\x03\x04' )
UNPACK_pkzip2=$( printf 'PK\x05\x06' )
UNPACK_pkzip3=$( printf 'PK\x07\x08' )
UNPACK_7z=$( printf '7z\xBC\xAF\x27' )
UNPACK_rar=$( printf '\x52\x61\x72\x21\x1A' )
UNPACK_tar=


function unpack {
	local head root pwd
	read -n 5 head ||
		exit $?

	# Goto root
	if [[ $root ]] ; then
		pwd=$( pwd )
		cd $root || rtn=$?
		if [[ $rtn -gt 0 ]] ; then
			throw "cant goto root"
			return $rtn
		fi
	fi

	# Is it PKZIP?
	if [[ ${head:0:2} == $UNPACK_pkzip1 || ${head:0:2} == $UNPACK_pkzip2 || ${head:0:2} == $UNPACK_pkzip3 ]] ; then
		check_command unzip ||
			log_fatal "unzip not found"
		[[ $UNZIP_TEMPFILE ]] ||
			UNZIP_TEMPFILE=$( mktemp )
		( printf $head && cat - ) 1> $UNZIP_TEMPFILE
		unzip $UNZIP_TEMPFILE ||
			exit $?

	# Is it 7Zip?
	elif [[ ${head:0:5} == $UNPACK_7zip ]] ; then
		check_command 7z ||
			log_fatal "7z not found"
		( printf $head && cat - ) | \
			7z x -si ||
				exit $?

	# Is it rar?
	elif [[ ${head:0:5} == $UNPACK_rar ]] ; then
		check_command unrar ||
			log_fatal "unrar not found"
		[[ $UNZIP_TEMPFILE ]] ||
			UNZIP_TEMPFILE=$( mktemp )
		( printf $head && cat - ) 1> $UNZIP_TEMPFILE
		unrar $UNZIP_TEMPFILE ||
			exit $?

	# Is it tarball?
	elif true || read -n 241 tail && [[ ${tail:241:5} == ustar ]] ; then	# FIXME: assumes tarball
		( printf $head$tail && cat - ) | \
			tar -xf - ||
				exit $?

	# IDK :(
	else
		throw "I dont know what file type this is, or it isnt archived"
		( printf $head && cat - )
		return 3

	fi

	[[ $pwd ]] &&
		cd $pwd
	return $?
}


