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

# Check if interpreter supports feature
test "/"$( ps -o comm,pid | grep -Fe $$ - | cut -d \  -f 1 - ) == "/bash" &&
	LOG_ISBASH=1 ||
	LOG_ISBASH=0

function log_log {
	# Checks arguments
	if [[ $# -lt 2 ]] ; then
		log_log 'err' "log_log: not enough arguments"
		return 1
	fi
	local rtn=0

	# Check call stack, create log text
	local log_text
	chk_true $LOG_ISBASH &&
		log_text="${FONT_RED}${1}: $APPLICATION_NAME: ${FUNCNAME[*]}: ${2}${FONT_DEFAULT}" ||
		log_text="${FONT_RED}${1}: $APPLICATION_NAME: ${2}${FONT_DEFAULT}"

	# Log to terminal
	if chk_true $LOG_TERMINAL ; then
		echo "$log_text" 1>&2

	# Log to file
	fi;if chk_true "$LOG_FILE" ; then
		echo "$log_text" >> "$LOG_FILE"
		if test $? -gt 0 ; then
			LOG_FILE="" log_log 'err' "log_log: cannot log to file $LOG_FILE"
			rtn=$(( rtn + 1 ))
		fi

	# Log to syslog
	fi;if chk_true "$LOG_SYSLOG" && chk_cmd logger ; then
		logger -p user."$1" "$log_text"
		if test $? -gt 0 ; then
			LOG_SYSLOG="false" log_log 'err' "log_log: cannot log to syslog"
			rtn=$(( rtn + 1 ))
		fi
	fi
}

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

function log_fatal {
	log_log crit "$1"
	return $?
}


