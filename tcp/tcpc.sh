#!/bin/bash
# Simple TCP client wrapper.
import misc/check
import misc/default

if check_command ncat ; then
	function tcpc_tcpc {
		ncat $ssl $host $port
		return $?
	}

elif check_command netcat ; then
	function tcpc_tcpc {
		[[ "$ssl" ]] &&
			log_fatal "ssl not supported (install ncat?)"
		netcat $host $port
		return $?
	}

elif check_command nc ; then
	function tcpc_tcpc {
		[[ "$ssl" ]] &&
			log_fatal "ssl not supported (install ncat?)"
		nc $host $port
		return $?
	}

else
	log_fatal "cannot find netcat program"

fi

function tcpc {
	local host port ssl file
	default host="$1" && shift
	default port="$1" && shift
	default ssl="$1" && shift
	default file="$1" && shift

	check_true "$ssl" &&
		ssl="--ssl" ||
		ssl=

	if [[ "$file" ]] ; then
		tcpc_tcpc < "$file"

	else
		tcpc_tcpc

	fi

	return $?
}

function tcpc_write {
	printf "$text$@" 1> $TCPC_ROOT/$TCPC_SELF
}

function tcpc_read {
	
}

function tcpc_new {
	
}

