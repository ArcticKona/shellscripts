#!/bin/bash
# Pluggable bash HTTP Server. 2019 Arctic Kona. No rights reserved.
import html_render
include httpd_error.htm httpd_index.htm

test "$HTTP_ROOT" == "" &&
	HTTPD_ROOT=$( pwd )
test "$HTTPD_PORT" == "" &&
	HTTTP_PORT=8080
test "$HTTPD_HOSTNAME" == "" &&
	HTTPD_HOSTNAME=$( hostname )

function httpd_error {
	printf "<HTML><HEAD><TITLE>$1</TITLE></HEAD><BODY><H1>$1</H1><HR/><P>HTTPD 2.0 @ $HTTPD_HOSTNAME:$HTTPD_PORT</P></BODY>\r\n"
	HTTPD_STATUS="$1"
	return 0
}

function httpd_index {
	# Is it a file?
	if test -f "$HTTPD_ROOT$HTTPD_URI" ; then
		cat "$HTTPD_ROOT$HTTPD_URI"
		if test $? -ne 0 ; then
			httpd_error "500 Internal Server Error"
			return $?
		fi
	fi

	# Is it a directory?
	if test -d "$HTTPD_ROOT$HTTPD_URI" ; then
		for i in 
	fi
}


