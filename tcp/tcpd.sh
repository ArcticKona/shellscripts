#!/bin/bash
# Simple TCP Server Wrapper. 2020 Kona Arctic. No rights reserved.
# FIXME: TCP connection might not automatically close on finish.
import misc/check
import misc/default
import log/log

default TCPD_PORT=1234
default TCPD_EXEC="echo See TCPD documentation"

log_warn "TCP server not secure! Do not expose to untrusted networks or users."

# Use ncat if possible
if check_command ncat ; then
	function tcpd_tcpd {
		export exec=$2
		ncat -lkp$1 -c "exec $TCPD_SHELL -c \"\$exec\""
	}

# busybox nc? FIXME: English only
elif check_command busybox && [[ $( busybox nc || true ) != "nc: applet not found" ]] ; then
	TCPD_TEMP=$( busybox nc -e || true )
	echo "$TCPD_TEMP" | read TCPD_TEMP
	[[ "$TCPD_TEMP" == "nc: invalid option -- 'e'" ]] &&
		log_fatal "Your version of netcat doesn not support command execution"

	function tcpd_tcpd {
		busybox nc -llp$1 -e $TCPD_SHELL -c "$2"
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
if [[ "$TCPD_SHELL" == "" ]] ; then
	if [[ $SHELL ]] ; then
		TCPD_SHELL=$SHELL
	elif check_command bash ; then
		TCPD_SHELL=bash
	elif check_command ash ; then
		TCPD_SHELL=ash
	else
		TCPD_SHELL=sh
	fi
fi

# Actual Wrapper
function tcpd {
	# Get arguments
	local port exec
	default port=$1 && shift
	default exec=$1 && shift
	default port=$TCPD_PORT
	default exec=$TCPD_EXEC

	# Include all functions, variables, and aliases
	exec="
	shopt -s expand_aliases
	shopt -s extglob
	$( set )
	$( alias )
	$exec
	"

	# Serve
	tcpd_tcpd $port "$exec"

	return $?
}


