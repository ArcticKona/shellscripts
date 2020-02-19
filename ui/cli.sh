#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import misc/argument
import misc/default
import misc/check
import log/log
import terminal/font

alias ui_arguments='
	local ARG_text ARG_title
	default ARG_text="${ARG_0}"
	default ARG_title="${ARG_1}"
'
alias ui_title='
	[[ "${ARG_title}" != "" ]] &&
		echo "${FONT_BOLD}${FONT_LINE}${ARG_title}${FONT_UNLINE}${FONT_UNBOLD}"
	[[ "${ARG_text}" != "" ]] &&
		echo "${ARG_text}"
'

function ui_info {
	argument
	ui_arguments
	ui_title

	return $?
}

function ui_warn {
	argument
	ui_arguments
	( ui_title ) 1>&2

	return $?
}

function ui_text {
	argument
	ui_arguments

	# Process title and text input
	local text
	[[ "${ARG_title}" != "" ]] &&
		text=">>> ${ARG_title} <<<
"
	[[ "${ARG_text}" != "" ]] &&
		text="$text${ARG_text}" ||
		text="${text}`cat - `"

	# Find an display program
	for editor in 'less' 'more' 'cat' ; do
		if chk_cmd $editor ; then
			$editor - <<< "$text"
			return $?
		fi
	done

	log_err "no text display program found"
	return 
}

function ui_entry {
	argument
	ui_arguments
	ui_title

	printf " > "
	head -n 1 -
	return $?
}

function ui_edit {
	local ARG_text ARG_title
	argument
	default ARG_file="${ARG_0}"
	default ARG_text="${ARG_1}"
	default ARG_title="${ARG_2}"

	# Provide information to user
	if [[ "${ARG_title}" != "" ]] || [[ "${ARG_text}" != "" ]] ; then
		ui_title
		echo "[ENTER]"
		head -n 1 -
	fi

	# Get STDIN or provided file
	local content
	if [[ "${ARG_file}" ]] ; then
		content="${ARG_file}"
	else
		content=$( mktemp ) ||
			return $?
		cat - 1> "$content" ||
			return $?
	fi

	# Edit!
	for editor in editor nano vim vi ed ; do
		if chk_cmd $editor ; then
			$editor "$content" ||
				return $?
			cat "$content"
			return $?
		fi
	done

	# Caveat: temp file not removed
	log_err "no editor found"
	return 1
}

function ui_list {
	argument
	ui_arguments
	ui_title


	log_err "not implemented"
}

function ui_checkbox {
	log_err "not implemented"
}

function ui_progress {
	log_err "not implemented"
}


