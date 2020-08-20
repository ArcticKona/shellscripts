#!/bin/bash
# Matches regexes in large files
import check/system
import misc/default

if check_command grep ; then
	function match {
		local regex IFS="
"
		default regex=$1 && shift

		if [[ $1 ]] ; then
			grep -e "$regex" - <<< $@ ||
				return $?

		else
			grep -e "$regex" - ||
				return $?

		fi
		return $?
	}

	function match_only {
		local regex IFS="
"
		default regex=$1 && shift

		if [[ $1 ]] ; then
			grep -oe "$regex" <<< $@ ||
				return $?

		else
			grep -oe "$regex" - ||
				return

		fi
		return $?
	}

elif check_command sed ; then
	function match {
		local regex IFS="
"
		default regex=$1 && shift

		if [[ $1 ]] ; then
			sed -ne "\|($regex)|p" - <<< $@ ||
				return $?

		else
			sed -ne "\|($regex)|p" - ||
				return $?

		fi
		return $?
	}

	function match_only {
		local regex IFS="
"
		default regex=$1 && shift

		if [[ $1 ]] ; then
			sed -ne "s|.*($regex)|\\1|g" <<< $@ ||
				return $?

		else
			sed -ne "s|.*($regex)|\\1|g" - ||
				return $?

		fi
		return $?
	}	

# FIXME: BASH only
else
	check_array ||
		log_fatal "pattern matching not supported yet (install grep)"

	function match {
		local regex temp
		default regex=$1 && shift

		if [[ $1 ]] ; then
			while [[ $# -gt 0 ]] ; do
				[[ $1 =~ $regex ]] &&
					echo $1
			done

		else
			while read temp ; do
				[[ $temp =~ $regex ]] &&
					echo $temp
			done

		fi
		return $?
	}

	function match_only {
		local regex IFS="
"
		default regex=$1 && shift

		if [[ $1 ]] ; then
			while [[ $# -gt 0 ]] ; do
				[[ $1 =~ $regex ]] &&
					printf "${BASH_REMATCH[*]}\n"
			done

		else
			while read temp ; do
				[[ $temp =~ $regex ]] &&
					printf "${BASH_REMATCH[*]}\n"
			done
		fi

		return $?
	}
fi

                                                                                                                                                     
