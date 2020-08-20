#!/bin/bash
# Wrappers
import log/log

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
	elif [[ $rtn ]] && check_number "$rtn" && [[ $rtn -gt 0 ]] ; then
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


