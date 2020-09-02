#!/bin/bash
# Simple TCP client wrapper.
import misc/check
import misc/default

if check_command ncat ; then
	function tcpc_tcpc {
		check_true "$ssl" &&
			ssl="--ssl" ||
			ssl=
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

elif echo > /dev/udp/localhost/0 ; then
		function tcp_tcpc {
		[[ "$ssl" ]] &&
			log_fatal "ssl not supported (install ncat?)"

		(
			exec 3<> /dev/tcp/$host/$port
			cat - <&3 &
			cat - >&3
		)

		return $?
	}

else
	function tcp_tcpc {
		log_fatal "cant find netcat program (install netcat?)"
	}

fi

function tcpc {
	local host port ssl file
	default host="$1" && shift
	default port="$1" && shift
#	default ssl="$1" && shift
#	default file="$1" && shift

#	if [[ "$file" ]] ; then
#		tcpc_tcpc < "$file"
#
#	else
		tcpc_tcpc
#
#	fi

	return $?
}


