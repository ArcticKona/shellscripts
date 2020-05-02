#!/bin/bash
# URL parser. 2020 Arctic Kona. No rights reserved.

function url_parse {
	local url proto host path port capture
	[[ "$url" ]] ||
		url="$1"
	[[ "$capture" ]] ||
		capture=URL

	# First, check protocol
	proto=$( grep -oEe "^[^:]+:" - <<< "$url" )
	[[ "$proto" ]] ||
		proto="http://"

	# Get host and port
	host=$( grep -oEe "^([^:]+:)?(//)?[^/]+" - <<< "$url" )
	path=$(( ${#host} + 1 ))
	host=$( grep -oEe "[^/]+$" - <<< "$host" )
	[[ "$host" ]] ||
		return 3
	port=$( grep -oEe ":[0-9]+$" - <<< "$host" )
	if [[ "$port" == "" ]] ; then
		[[ "$proto" == "https:" ]] &&
			port=443 ||
		[[ "$proto" == "http:" ]] &&
			port=80
	fi

	# Get path
	path=${url:$path:-1}
	[[ "$path" ]] ||
		path="/"

	# Record
	eval "${capture}_proto=\$proto"
	eval "${capture}_host=\$host"
	eval "${capture}_port=\$port"
	eval "${capture}_path=\$path"

	return 0
}

