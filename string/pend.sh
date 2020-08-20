#!/bin/bash
# Prepend append large files
import check/system

if check_command sed ; do
	function pend_pre {
		sed -e "s|^|$@|" -
		return $?
	}
	function pend_ap {
		sed -e "s|^|$@|" -
		return $?
	}

else
	function pend_pre {
		local temp
		while read temp ; do
			echo "$@$temp"
		done
	}
	function pend_ap {
		local temp
		while read temp ; do
			echo "$temp$@"
		done
	}

done


