#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import check/sys
import check/var
import log/log
import misc/default
import term/font

# Display simple information
function ui_cli_info {
	[[ "${title}" ]] &&
		echo "${FONT_BOLD}${FONT_LINE}${title}${FONT_UNLINE}${FONT_UNBOLD}"
	[[ "${text}" ]] &&
		echo "${text}"
	return $?
}

# Display a warning
function ui_cli_warn {
	ui_cli_info "${title}$1" "${text}$2" 1>&2
	return $?
}

# Display some text
# First, check what is usable
for UI_TEXT_PROGRAM in less more cat ; do
	check_command $UI_TEXT_PROGRAM &&
		break
done
function ui_cli_text {
	ui_cli_info "${title}" "${text}"

	# If file is specified, use that
	if [[ "${file}" ]] ; then
		$UI_TEXT_PROGRAM "${file}$1"

	# Otherwise, use STDIN
	else
		$UI_TEXT_PROGRAM -
		
	fi
	return $?
}

# Ask for a line of input
function ui_cli_entry {
	ui_info "${title}$1" "${text}$2"
	printf " > "
	head -n 1 -
	return $?
}

# Edit a file
# First, check what is usable
for UI_EDIT_PROGRAM in editor nano vim vi ed ; do
	check_command $UI_EDIT_PROGRAM &&
		break
done
function ui_cli_edit {
	ui_info "${title}$2" "${text}$3"

	# If file is specified, use that
	if [[ "${file}" ]] ; then
		$UI_EDIT_PROGRAM "${file}"

	# Otherwise, use STDIN. Please don't use STDIN
	else
		# First, create temporary file
		file=$( mktemp ) ||
			return $?
		cat - 1> $file

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
function ui_cli_list {
	local reponse index IFS
	IFS="
"
	index=0
	ui_info "${title}" "${text}"

	for reponse in $list ; do
		index=$(( $index + 1 ))
		echo "${index}.	$reponse" 1>&2
	done

	# Also, get 
	read -p " > " reponse ||
		return $?

	# and check that response is valid
	if ! check_number "$reponse" || [[ $reponse -lt 1 ]] || [[ $reponse -gt $index ]] ; then
		return 3
	fi

	echo "$reponse"
	return 0
}

function ui_cli_checkbox {
	log_fatal "not implemented"
}

# Progress bar
check_command tput &&
	UI_PROGRESS_WIDTH=$(( $( tput cols ) - 2 ))	# Please don't resize your virtual terminal
	UI_PROGRESS_WIDTH=10
UI_PROGRESS_DENOMINATOR=100
function ui_cli_progress {
	log_fatal "not implemented"
	
	local bar
	bar=$( printf "%-$(( $UI_PROGRESS_WIDTH * 0$1 / $UI_PROGRESS_DENOMINATOR ))s" "=" )
	echo "[$bar]"
}


