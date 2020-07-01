#!/bin/bash
# Wrapper for cat
import misc/check

if check_command cat ; then
	function cat {
		local file IFS=
		$( which cat ) $file $@
		return $?
	}

else
	# FIXME: Does not support all features
	function cat {
		local file buffer IFS=
		while [[ $# -gt 0 ]] ; do
			(
				while read buffer ; do	# FIXME: Does not work with binary
					echo "$buffer"
				done
			) < "$1"
			shift
		done
	}

fi

# TODO: head and tails


