# 
# Find mktemp
if which mktemp 1> /dev/null ; then
	function mktemp {
		local type

		# Capture?
		if [[ "$capture" ]] ; then
			eval "$capture=\$( $0 $1 )"
			return $?
		fi

		# Type
		[[ "$type" ]] &&
			type="-$type" ||
			type=$1

		# Exec.
		$( which mktemp ) $type
		return $?
	}

else
	function mktemp {
		local type

		# Capture?
		if [[ "$capture" ]] ; then
			eval "$capture=\$( $0 $1 )"
			return $?
		fi

		# Find directory
		if [[ -d /tmp ]] ; then
			file="/tmp/$$$RANDOM$RANDOM$RANDOM"
		elif [[ -d /var/tmp ]] ; then
			file="/var/tmp/$$$RANDOM$RANDOM$RANDOM"
		else
			return 2
		fi

		# Make file
		if [[ -f "$file" ]] ; then
			if [[ "$RANDOM" ]] ; then
				import_mktemp $1
				return $?
			else
				return 2
			fi
		fi

		# Exec.
		echo "$file"
		if [[ $type == d ]] || [[ "$1" == "-d" ]] ; then
			mkdir "$file"
		else
			touch "$file"
		fi

		return $?
	}

fi

