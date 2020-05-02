#!/bin/bash
# Simple TCP Server Wrapper. 2020 Kona Arctic. No rights reserved.
# FIXME: TCP connection might not automatically close on finish.
import misc/check
import log/log

# Use ncat if possible
if check_command ncat ; then
	function tcpserv_listen {
		ncat -lkp$1 -c "exec $TCPSERV_SHELL -c \"\$TCPSERV_EXEC\""
	}

# busybox nc? FIXME: English only FIXME: busybox netcat
elif check_command busybox && [[ $( busybox nc || true ) != "nc: applet not found" ]] ; then
	TCPSERV_TEMP=$( busybox nc -e || true )
	TCPSERV_TEMP=$( head -n 1 - <<< "$TCPSERV_TEMP" )
	[ "$TCPSERV_TEMP" == "nc: invalid option -- 'e'" ]] &&
		log_fatal "Your version of netcat doesn not support command execution"

	function tcpserv_listen {
		busybox nc -llp$1 -e $TCPSERV_SHELL -c "$2"
		return $?
	}

# BSD netcat
elif check_command netcat ; then
	log_fatal "BSD netcat not yet supported"

# Oops...
else
	log_fatal "Cannot find netcat program"

fi

# Get shell
if check_command bash ; then
	TCPSERV_SHELL=bash
elif check_command ash ; then
	TCPSERV_SHELL=ash
else
	TCPSERV_SHELL=sh
fi

# Actual Wrapper
function tcpserv {
	# Get arguments
	local port exec
	if [[ "$port" == "" ]] ; then
		port="$1"
		shift
	fi
	if [[ "$exec" == "" ]] ; then
		exec="$1"
		shift
	fi

	check_command declare ||
		log_fatal "comand declare not found"
	# Include all functions and aliases
	exec="
	$( set )
	$( alias )
	$exec
	"

	# Serve
	export TCPSERV_PORT=$port
	export TCPSERV_EXEC="$exec"
	tcpserv_listen $port "$exec"

	return $?
}


