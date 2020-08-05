#!/bin/bash
# Packs all import and include requirements
source "import.sh"

# Do for arguments
if [[ $# -gt 0 ]] ; then
	IFS=
	for item in $@ ; do
		$0 < $item > $item.sh.bat ||
			echo "ERROR: $?"
	done

	exit
fi

# Special headers
function compile_header {
	printf '#!/bin/bash\n\r\n@gOTo :windows4c42170f630f34fb075276e682c66008\r\necho \"Above \\"@gOTo\\" can be ignored.\"\necho "This script was auto-generated."\necho "Script libraries and utilities by Kona Arctic"\nclear\n'
	import_fetch import
	cat -
	printf '\r\n:windows4c42170f630f34fb075276e682c66008\r\necho Not yet available for Windows(tm)\r\npause\r\n\r\n'
	# TODO: Download busybox + bash on Windows
}

# Do for imports
function compile_import {
	while read temp ; do
		# Ignore as required
		if [[ ${temp:0:1} == '#' ]] || [[ ${temp:0:6} == source ]] || [[ ${temp:0:6} == include ]] ; then
			echo $temp

		# Process import
		elif [[ ${temp:0:6} == import ]] ; then
			IFS=" "
			for item in ${temp:6} ; do
				[[ ${item:0:1} == "#" ]] &&
					break

				import_check $item &&
					continue

				IMPORT_ALREADY="$IMPORT_ALREADY
$item"

				temp=$( import_fetch $item )
				compile_import <<< $temp

			done

		# Finish if anything else
		else
			cat -
			break

		fi
	done
}

# Do for includes
function compile_include {
	# TODO: implement
	cat -
}

# Run
compile_import | \
compile_include | \
compile_header

