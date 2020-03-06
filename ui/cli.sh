#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import misc/default
import misc/check
import log/log
import terminal/font

alias ui_title='
	[[ "${title}" != "" ]] &&
		echo "${FONT_BOLD}${FONT_LINE}${title}${FONT_UNLINE}${FONT_UNBOLD}"
	[[ "${text}" != "" ]] &&
		echo "${text}"
'

function ui_info {
	local text title
	default text="$1"
	default title="$2"

	ui_title

	return $?
}

function ui_warn {
	local text
	default text="$1"
	default title="$2"

	{ ui_title } 1>&2

	return $?
}

function ui_text {
	local file
	default file="$1"

	# Process title and text input
	[[ "${text}" == "" ]] &&
		text="$( cat $file )"
	[[ "${title}" == "" ]] ||
		text=">>> ${title} <<<
$text"

	# Find an display program
	for editor in 'less' 'more' 'cat' ; do
		if check_command $editor ; then
			$editor - <<< "$text"
			return $?
		fi
	done

	log_err "no text display program found"
	return
}

function ui_entry {
	ui_title

	printf " > "
	if [[ "$1" == "" ]] ; then
		head -n 1 -
	else
		$1=$( head -n 1 - )
	fi

	return $?
}

function ui_edit {
	# Provide information to user
	if [[ "${title}" != "" ]] || [[ "${text}" != "" ]] ; then
		ui_title
		echo "[ENTER]"
		read -n 1 -s
	fi


	# Get STDIN or provided file
	if [[ "${file}" == "" ]] ; then
		file=$( mktemp ) ||
			return $?
		cat - 1> "$file" ||
			return $?
	fi

	# Edit!
	for editor in editor nano vim vi ed ; do
		if check_command $editor ; then
			$editor "$file"
			rtn=$?
			if [[ -f "$file" ]] ; then
				if [[ $rtn -eq 0 ]] ; then
					cat "$file"
					rtn=$?
				fi
				rm "$file"
				return $rtn
			fi
			[[ $rtn -gt 0 ]] &&
				return $rtn ||
				return 3
		fi
	done

	# Caveat: temp file not removed
	log_err "no editor found"
	return 1
}

function ui_list {
	ui_title

	if 
	while true ; do
		
	done

	return 0
}

function ui_checkbox {
	log_err "not implemented"
}

function ui_progress {
	log_err "not implemented"
}


