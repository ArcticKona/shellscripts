#!/bin/bash
# Decompresses stdin to stdout
import misc/check
import log/log
import system/cat

# Wrappers
if ! check_command gunzip ; then
	function gunzip {
		local IFS=
		check_command gzip ||
			log_fatal "gzip not found"
		gzip -d $@
		return
	}
fi

if ! check_command bunzip2 ; then
	function bunzip2 {
		local IFS=
		check_command bzip2 ||
			log_fatal "bzip2 not found"
		bzip2 -d $@
		return
	}
fi

# Magic numbers
EXPAND_gzip=$( printf '\x1F\x8B' )
EXPAND_bzip2=BZh
EXPAND_xz=$( printf '\xFD7zX' )


function expand {
	local head
	read -n 4 head

	# Is it gzip?
	if [[ ${head:0:2} == $EXPAND_gzip ]] ; then
		( printf $head && cat - ) | \
			gunzip -c - ||
				exit $?

	# Is it bzip2?
	elif [[ ${head:0:3} == $EXPAND_bzip2 ]] ; then
		( printf $head && cat - ) | \
			bunzip2 -c - ||
				exit $?

	# Is it xz?
	elif [[ ${head:0:4} == $EXPAND_xz ]] ; then
		check_command xz ||
			log_fatal "xz not found"
		( printf $head && cat - ) | \
			xz -dc - ||
				exit $?

	# IDK :(
	else
		log_warn "I dont know what file type this is, or it isnt compressed"
		( printf $head && cat - )
		return 3

	fi

	return $?
}


