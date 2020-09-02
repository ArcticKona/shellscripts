#!/bin/bash
# Filters repeating. 2020 Kona Arctic. Some rights reserved.
import misc/check

if check_command uniq ; then
	function unique {
		uniq -
		return $?
	}

else
	function unique {
		local line last IFS="
"

		while read line ; do
			if [[ ! $line == $last ]] ; then
				echo $line
				last=$line
			fi
		done

		return 0
	}

fi


