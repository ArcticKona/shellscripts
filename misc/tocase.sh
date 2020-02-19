#!/bin/bash
# To lowercase or uppercase. 2019 Arctic Kona. No rights reserved.
import misc/check
import log/log

# To lower case arguments if there or stdin, using tr awk sed or perl
function tocase_lower {
	if [[ $# -gt 0 ]] ; then
		if chk_cmd tr ; then
			tr "[:upper:]" "[:lower:]" <<< "$@"
			return $?
		elif chk_cmd awk ; then
			awk '{print tolower($0)}' <<< "$@"
			return $?
		elif chk_cmd sed ; then
			sed -e 's/\(.*\)/\L\1/' <<< "$@"
			return $?
		elif chk_cmd perl ; then
			perl -ne 'print lc' <<< "$@"
			return $?
		else
			log_err "no commands found"
			return 1
		fi
	else
		if chk_cmd tr ; then
			tr "[:upper:]" "[:lower:]"
			return $?
		elif chk_cmd awk ; then
			awk '{print tolower($0)}'
			return $?
		elif chk_cmd sed ; then
			sed -e 's/\(.*\)/\L\1/'
			return $?
		elif chk_cmd perl ; then
			perl -ne 'print lc'
			return $?
		else
			log_err "no commands found"
			return 1
		fi
	fi
}

# To upper case arguments if there or stdin, using tr awk sed or perl
function tocase_upper {
	if [[ $# -gt 0 ]] ; then
		if chk_cmd tr ; then
			tr "[:lower:]" "[:upper:]" <<< "$@"
			return $?
		elif chk_cmd awk ; then
			awk '{print toupper($0)}' <<< "$@"
			return $?
		elif chk_cmd sed ; then
			sed -e 's/\(.*\)/\U\1/' <<< "$@"
			return $?
		elif chk_cmd perl ; then
			perl -ne 'print uc' <<< "$@"
			return $?
		else
			log_err "no commands found"
			return 1
		fi
	else
		if chk_cmd tr ; then
			tr "[:lower:]" "[:upper:]"
			return $?
		elif chk_cmd awk ; then
			awk '{print toupper($0)}'
			return $?
		elif chk_cmd sed ; then
			sed -e 's/\(.*\)/\U\1/'
			return $?
		elif chk_cmd perl ; then
			perl -ne 'print uc'
			return $?
		else
			log_err "no commands found"
			return 1
		fi
	fi
}


