#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import misc/argument
import misc/default
import log/log

# Display simple information
function ui_zenity_info {
	zenity --info --title="${title}" --text="${text}"
	return $?
}

# Display a warning
function ui_zenity_warn {
	zenity --error --title="${title}$2" --text="${text}$1"
	return $?
}

# Display some text
function ui_zenity_text {	
	if [[ "$file" ]] ; then
		zenity --text-info --title="${title}" < "$file"
	else
		zenity --text-info --title="${title}"
	fi
	return $?
}

# Ask for a line of input
function ui_zenity_entry {
	zenity --entry --title="${title}" --text="${text}" --entry-text="${entry}"
	return $?
}

# Edit a file
function ui_zenity_edit {
	if [[ "$file" ]] ; then
		title=$( zenity --text-info --editable --title="${title}" < "$file" )
		printf "$title" 1> "$file"
	else
		zenity --text-info --editable --title="${title}"
	fi
	return $?
}

# Ask to select off of a list
function ui_zenity_list {
	zenity --list --title="${title}" --text="${text}" --column="" <<< "$list"
	return $?
}

function ui_zenity_checkbox {
	log_fatal "Function not yet implemented"
}


function ui_zenity_progress {
	log_fatal "Function not yet implemented"
}

