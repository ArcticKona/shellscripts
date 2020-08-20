#!/bin/bash
# bash HTTP Server. 2019 Arctic Kona. No rights reserved.
# TODO:
# *	TCP stream hijack support
# *	Does not work well with large files
# *	Operate keep-alives

import misc/default
import tcp/tcpd

default HTTPD_ROOT=$( pwd )
default HTTPD_PORT=8080
default HTTPD_EXEC=httpd_index

# Reports error
function httpd_error {
	printf "<HTML>\r\n\t<HEAD>\r\n\t\t<TITLE>\r\n\t\t\t$1\r\n\t\t</TITLE>\r\n\t</HEAD>\r\n\t<BODY>\r\n\t\t<H1>\r\n\t\t\t$1\r\n\t\t</H1>\r\n\t\t<HR/>\r\n\t\t<P>\r\n\t\t\tkona/2.5.0 @ $( hostname ):$HTTPD_PORT\r\n\t\t</P>\r\n\t</BODY>\r\n</HTML>\r\n"
	HTTPD_STATUS="$1"
	return 0
}

# Generates index
function httpd_index {
	local IFS
	IFS="
"

	# Is it a file?
	if [[ -f "$HTTPD_ROOT$HTTPD_URI" ]] ; then
		cat "$HTTPD_ROOT$HTTPD_URI"
		if [[ $? -gt 0 ]]; then
			httpd_error "500 Internal Server Error"
			return $?
		fi

	# Is there a index.html?
	elif [[ -f "$HTTPD_ROOT$HTTPD_URI/index.html" ]] ; then
		cat "$HTTPD_ROOT$HTTPD_URI/index.html"

	elif [[ -f "$HTTPD_ROOT$HTTPD_URI/index.htm" ]] ; then
		cat "$HTTPD_ROOT$HTTPD_URI/index.htm"

	# Is it a directory?
	elif [[ -d "$HTTPD_ROOT$HTTPD_URI" ]] ; then
		printf "<HTML>\r\n\t<HEAD>\r\n\t\t<TITLE>\r\n\t\t\tIndex of $HTTPD_URI\r\n\t\t</TITLE>\r\n\t</HEAD>\r\n\t<BODY>\r\n\t\t<H1>\r\n\t\t\tIndex of $HTTPD_URI\r\n\t\t</H1>\r\n\t\t<UL>\r\n\t\t\t<LI><A HREF=\"/\">/</A></LI>\r\n\t\t\t<LI><A HREF=\"$HTTPD_URI/$HTTPD_FILE/..\">../</A></LI>\r\n"
		for HTTPD_FILE in $( ls "$HTTPD_ROOT$HTTPD_URI" ) ; do
			printf "\t\t\t<LI><A HREF=\"$HTTPD_URI/$HTTPD_FILE\">$HTTPD_FILE$( [[ -d "$HTTPD_ROOT$HTTPD_URI$HTTPD_FILE" ]] && echo / )</A></LI>\r\n"
		done
		printf "\r\n\t\t</UL>\r\n\t\t<HR/>\r\n\t\t<P>\r\n\t\t\tkona/2.5.0 @ $( hostname ):$HTTPD_PORT\r\n\t\t</P>\r\n\t</BODY>\r\n</HTML>\r\n"

	# Otherwise, report not found
	else
		httpd_error "404 Not Found"

	fi
	return $?
}

function httpd_httpd {
	local line IFS
	IFS="
"
	HTTPD_RESPONSE=

	# Get request
	read line
	HTTPD_VERSION=${line##* }
	HTTPD_METHOD=${line%% *}
	line=${line% *}
	HTTPD_URI=${line##* }
	if [[ ${HTTPD_VERSION:0:4} != HTTP ]] ; then	# Bad request
		printf "HTTP/1.0 400 Bad Request\r\Date: $( date -u +%a,\ %d\ %b\ %Y\ %H:%M:%S\ GMT )\r\nContent-length: 0\r\n\r\n"
		return $?
	fi

	# Get headers
	while true ; do
		read $line ||
			break
		line=${line/$( printf \\r )/}
		line=${line//-/_}
		[[ $line =~ "[a-zA-Z0-9-]" ]] ||
			continue
		[[ $line ]] ||
			break
		eval "HTTPD_${line%%: *}=\${line#*: }"
	done

	# Execute!
	HTTPD_STATUS=0
	HTTPD_RESPONSE=$( $HTTPD_EXEC )
	rtn=$?
	if [[ $HTTPD_STATUS -eq 0 ]] ; then	# Guess an exit status
		[[ $rtn -eq 0 ]] &&
			HTTPD_STATUS=200 ||
			HTTPD_STATUS=500
	fi

	# Execute response
	printf "HTTP/1.0 $HTTPD_STATUS\r\n"
	printf "Date: $( date -u +%a,\ %d\ %b\ %Y\ %H:%M:%S\ GMT )\r\n"
	printf "Server: kona/2.5.0\r\n"
	printf "Connection: close\r\n"
	printf "Content-length: ${#HTTPD_RESPONSE}\r\n"
	printf "\r\n"
	echo $HTTPD_RESPONSE

	return $?
}

# Wrapper
function httpd {
	local port exec
	default port=$1 && shift
	default exec=$1 && shift
	default port=$HTTPD_PORT
	[[ $exec ]] &&
		HTTPD_EXEC="$exec"

	exec=httpd_httpd port=$port tcpd
	return $?
}


