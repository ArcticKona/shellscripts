#!/bin/bash
# Wrapper HTTP client
# TODO:
# *   Support for request and response headers
# *   Fallback to TCPC as required
import misc/check
import log/log
import tcp/tcpc

# Curl?
if check_command curl ; then
	function httpc_httpc {
		local IFS="
"
		curl -s -X $method -H "User-Agent: $user_agent" -d @- -L "$url" $@
		return $?
	}

# Wget?
elif check_command wget ; then
	function httpc_httpc {
		local IFS="
"
		if [[ $method == GET ]] || [[ $method == HEAD ]] || [[ $method == DELETE ]] ; then
			wget -U $user_agent -qO - "$url" $@
		else
			wget -U $user_agent --method=$method -i - -qO - "$url" $@	# May not work in all versions of wget
		fi
		return $?
	}

# Busybox wget?
# TODO: Implement

# TODO: Use tcpc
else
	function httpc_httpc {
		log_fatal "I can't find either curl or wget!"
	}

fi

function httpc {
	local capture method user_agent url body IFS="
"
	if [[ $capture ]] ; then
		eval "$capture=\$( method=\$method user_agent=\$user_agent body=\$body httpc $url \$@ )"
		return $?
	fi
	[[ $method ]] ||
		method=GET

	# If any of the methods HEAD GET DELETE is used, do not use body
	if [[ $method == GET ]] || [[ $method == HEAD ]] || [[ $method == DELETE ]] ; then
		true | \
			httpc_httpc $@

	# Otherwise use body as provided
	elif [[ $body ]] ; then
		printf "%s" $body | \
			httpc_httpc $@

	# Or get body from stdin
	else
		httpc_httpc $@

	fi

	return $?
}


