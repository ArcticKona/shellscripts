#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import misc/default
import misc/check
import log/log
import term/font

# Display simple information
function ui_info {
	local title text

	[[ "${title}$1" != "" ]] &&
		echo "${FONT_BOLD}${FONT_LINE}${title}$1${FONT_UNLINE}${FONT_UNBOLD}"
	[[ "${text}$2" != "" ]] &&
		echo "${text}$2"

	return $?
}

# Display a warning
function ui_warn {
	local title text

	ui_info "${title}$1" "${text}$2" 1>&2

	return $?
}

# Display some text
# First, check what is usable
for UI_TEXT_PROGRAM in less more cat ; do
	check_command $UI_TEXT_PROGRAM &&
		break
done
function ui_text {
	local title text file
	ui_info "${title}$2" "${text}$3"

	# First, check for program
	if [[ "$UI_TEXT_PROGRAM" == "" ]] ; then
		log_error "no text display program found"
		return 10
	fi

	# If file is specified, use that
	if [[ "${file}$1" ]] ; then
		$UI_TEXT_PROGRAM "${file}$1"

	# Otherwise, use STDIN
	else
		$UI_TEXT_PROGRAM -
		
	fi
	return $?
}

# Ask for a line of input
function ui_entry {
	local title text capture
	ui_info "${title}$1" "${text}$2"

	printf " > "
	# If a capture variable is specified, use that
	if [[ "${capture}$3" ]] ; then
		read "${capture}$3"

	# Otherwise, output to STDOUT
	else
		head -n 1 -

	fi
	return $?
}

# Edit a file
# First, check what is usable
for UI_EDIT_PROGRAM in editor nano vim vi ed ; do
	check_command $UI_TEXT_PROGRAM &&
		break
done
function ui_edit {
	local title text file
	ui_info "${title}$2" "${text}$3"

	# First, check for program
	if [[ "$UI_EDIT_PROGRAM" == "" ]] ; then
		log_error "no text edit program found"
		return 10
	fi

	# If file is specified, use that
	if [[ "${file}$1" ]] ; then
		$UI_EDIT_PROGRAM "${file}$1"

	# Otherwise, use STDIN. Please don't use STDIN
	else
		# First, create temporary file
		local file
		file=$( mktemp ) ||
			return $?
		cat - 1> $file
		rtn=$?
		if [[ $rtn -gt 0 ]] ; then
			rm "$file" 2> /dev/null
			return $rtn
		fi
		
		# Then edit it
		$UI_EDIT_PROGRAM $file
		rtn=$?
		if [[ -f "$file" ]] ; then
			cat "$file"
			rm "$file" 2> /dev/null
		fi
		return $rtn
		
	fi
	return $?
}

# Ask to select off of a list
function ui_list {
	local title text file capture
	local reponse index
	index=0
	ui_info "${title}" "${text}"

	# NOTE: CASE AND PASTE
	# If a list arguments was specified, use that
	if [[ "$list" ]] ; then
		for reponse in $list ; do
			index=$(( $index + 1 ))
			echo "$index $response"
		done

	# If arguments were specified, use that
	elif [[ $# -gt 0 ]] ; then
		while [[ $# -gt 0 ]] ; do
			index=$(( $index + 1 ))
			echo "$index $1"
			shift
		done

	# If a file was specified, use that
	elif [[ "$file" ]] ; then
		for reponse in $( cat "$file" ) ; do
			index=$(( $index + 1 ))
			echo "$index $response"
		done

	# Otherwise, use STDIN
	else
		for reponse in $( cat - ) ; do
			index=$(( $index + 1 ))
			echo "$index $reponse"
		done
		
	fi

	# Also, get and check that response is valid
	read -p " > " response ||
		return $?
	if ! check_number || [[ $response -lt 1 ]] || [[ $response -gt $index ]] ; then
		return 10
	fi

	# If variable is specified, use that. Or use STDOUT
	[[ "${capture}" ]] &&
		eval "$capture=\"\$response\"" ||
		echo "$response"
		
	return 0
}

function ui_checkbox {
	log_fatal "not implemented"
}

# Progress bar
check_command tput &&
	UI_PROGRESS_WIDTH=$(( $( tput cols ) - 2 ))	# Please don't resize your virtual terminal
	UI_PROGRESS_WIDTH=10
UI_PROGRESS_DENOMINATOR=100
function ui_progress {
	log_fatal "not implemented"
	
	local bar
	bar=$( printf "%-$(( $UI_PROGRESS_WIDTH * 0$1 / $UI_PROGRESS_DENOMINATOR ))s" "=" )
	echo "[$bar]"
}


