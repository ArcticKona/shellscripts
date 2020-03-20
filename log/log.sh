#!/bin/bash
# Simple logging. 2019 Arctic Kona. No rights reserved.
import program
import misc/default
import misc/check
import terminal/font
default LOG_TERMINAL=1
default LOG_FILE=0
default LOG_SYSLOG=0
default LOG_LEVEL=warn

#
# Core logging functuions
function log_log {
	local IFS=" "

	# Checks arguments
	if [[ $# -lt 2 ]] ; then
		log_log 'err' "log_log: not enough arguments"
		return 1
	fi
	local rtn=0

	# Check call stack, create log text
	local log_text
	check_array &&
		log_text="${FONT_RED}${1}: $PROGRAM_NAME: ${FUNCNAME[*]}: ${2}${FONT_DEFAULT}" ||
		log_text="${FONT_RED}${1}: $PROGRAM_NAME: ${2}${FONT_DEFAULT}"

	# Log to terminal
	if check_true $LOG_TERMINAL ; then
		echo "$log_text" 1>&2

	# Log to file
	fi;if check_true "$LOG_FILE" ; then
		echo "$log_text" >> "$LOG_FILE"
		if test $? -gt 0 ; then
			LOG_FILE="" log_log 'err' "log_log: cannot log to file $LOG_FILE"
			rtn=$(( rtn + 1 ))
		fi

	# Log to syslog
	fi;if check_true "$LOG_SYSLOG" && check_command logger ; then
		logger -p user."$1" "$log_text"
		if test $? -gt 0 ; then
			LOG_SYSLOG="false" log_log 'err' "log_log: cannot log to syslog"
			rtn=$(( rtn + 1 ))
		fi
	fi
}

#
# Exits after log_crit
function log_fatal {
	local log_rtn=$?

	log_log crit "$1" ||
		exit $?

	if check_number $2 ; then
		exit $2
	elif [[ $log_rtn -gt 0 ]] ; then
		exit $log_rtn
	elif check_number "$rtn" && [[ $rtn -gt 0 ]] ; then
		exit $rtn
	else
		exit 10
	fi
}

#
# Alias

function log_info {
	log_log 'info' "$1"
	return $?
}

function log_warn {
	log_log warn "$1"
	return $?
}

function log_err {
	log_log err "$1"
	return $?
}

function log_crit {
	log_log crit "$1"
	return $?
}

function log_informal {
	log_log 'info' "$1"
	return $?
}

function log_warning {
	log_log warn "$1"
	return $?
}

function log_error {
	log_log err "$1"
	return $?
}

function log_critical {
	log_log crit "$1"
	return $?
}


