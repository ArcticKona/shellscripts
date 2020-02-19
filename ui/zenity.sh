#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import misc/argument
import misc/default
import log/log

alias ui_arguments='
	local ARG_text ARG_title
	default ARG_text="${ARG_0}"
	default ARG_title="${ARG_1}"
'

function ui_info {
	argument
	ui_arguments

	zenity --info --title="${ARG_title}" --text="${ARG_text}"
	return $?
}

function ui_warn {
	argument
	ui_arguments

	zenity --error --title="${ARG_title}" --text="${ARG_text}"
	return $?
}

function ui_text {
	argument
	ui_arguments

	zenity --entry-info --title="${ARG_title}"
	return $?
}

function ui_entry {
	argument
	ui_arguments

	zenity --entry --title="${ARG_title}" --text="${ARG_text}" --entry-text="${ARG_entrytext}"
	return $?
}

function ui_edit {
	argument
	ui_arguments

	zenity --entry-info --editable --title="${ARG_title}"
	return $?
}

function ui_list {
	argument
	ui_arguments

	zenity --list --title="${ARG_title}" --text="${ARG_text}" --column=""
	return $?
}

function ui_checkbox {
	log_err "Function not yet implemented"
}


function ui_progress {
	log_err "Function not yet implemented"

}

