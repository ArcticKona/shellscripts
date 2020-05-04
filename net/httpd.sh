#!/bin/bash
# Pluggable bash HTTP Server. 2019 Arctic Kona. No rights reserved.
#import html_render
import misc/default
import net/tcpd

default HTTPD_ROOT=$( pwd )
default HTTPD_PORT=8080
default HTTPD_EXEC=httpd_index

function httpd_error {
	printf "<HTML>\r\n\t<HEAD>\r\n\t\t<TITLE>\r\n\t\t\t$1\r\n\t\t</TITLE>\r\n\t</HEAD>\r\n\t<BODY\r\n\t\t><H1>\r\n\t\t\t$1\r\n\t\t</H1>\r\n\t\t<HR/>\r\n\t\t<P>\r\n\t\t\tHTTPD 2.0 @ $( hostname ):$HTTPD_PORT\r\n\t\t</P>\r\n\t</BODY>\r\n</HTML>\r\n"
	HTTPD_STATUS="$1"
	return 0
}

function httpd_index {
	# Is it a file?
	if [[ -f "$HTTPD_ROOT$HTTPD_URI" ]] ; then
		cat "$HTTPD_ROOT$HTTPD_URI"
		if test $? -ne 0 ; then
			httpd_error "500 Internal Server Error"
			return $?
		fi
	fi

	# Is it a directory?
	if [[ -d "$HTTPD_ROOT$HTTPD_URI" ]] ; then
		printf "<HTML>\r\n\t<HEAD>\r\n\t\t<TITLE>\r\n\t\t\tIndex of $HTTPD_URI\r\n\t\t</TITLE>\r\n\t</HEAD>\r\n\t<BODY\r\n\t\t><H1>\r\n\t\t\tIndex of $HTTPD_URI\r\n\t\t</H1>\r\n\t\t<UL>\r\n\t\t\t<LI><A HREF=\"/\">/</A></LI>\r\n\t\t\t<LI><A HREF=\"$HTTPD_URI/$HTTPD_FILE/..\">../</A></LI>\r\n"
		for HTTPD_FILE in $( ls "$HTTPD_ROOT$HTTPD_URI" ) ; do
			printf "\t\t\t<LI><A HREF=\"$HTTPD_URI/$HTTPD_FILE\">$HTTPD_FILE$( [[ -d "$HTTPD_ROOT$HTTPD_URI$HTTPD_FILE" ]] && echo / )</A></LI>\r\n"
		done
		printf "\r\n\t\t</UL>\r\n\t\t<HR/>\r\n\t\t<P>\r\n\t\t\tHTTPD 2.0 @ $( hostname ):$HTTPD_PORT\r\n\t\t</P>\r\n\t</BODY>\r\n</HTML>\r\n"
	fi
}

function httpd_httpd {
	read -t 3 HTTPD_LINE
	
}

tcpd $HTTPD_PORT httpd_httpd



