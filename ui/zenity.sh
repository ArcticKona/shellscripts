#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import_private
import misc/argument
import misc/default
import log/log

# Display simple information
function ui_info {
	local title text

	zenity --info --title="${title}$2" --text="${text}$1"

	return $?
}

# Display a warning
function ui_warn {
	local title text
	zenity --error --title="${title}$2" --text="${text}$1"

	return $?
}

# Display some text
function ui_text {	
	local title file

	# If a file is specified, use that
	if [[ "${file}$1" ]] ; then
		zenity --text-info --title="${title}$2" < "${file}$1"

	# Else, use STDIN
	else
		zenity --text-info --title="${title}$2"

	fi
	return $?
}

# Ask for a line of input
function ui_entry {
	local title text entrytext capture

	# If a capture variable is specified, use that
	if [[ "${capture}$3" == "" ]] ; then
		zenity --entry --title="${title}$2" --text="${text}$1" --entry-text="${entrytext}"

	# Otherwise, output to STDOUT
	else
		eval "${capture}$3=\$( zenity --entry --title=\"\${title}\$2\" --text=\"\${text}\$1\" --entry-text=\"\${entrytext}\" )"

	fi
	return $?
}

# Edit a file
function ui_edit {
	local title file

	# If a file is specified, use that
	if [[ "${file}$1" ]] ; then
		zenity --text-info --editable --title="${title}$2" < "${file}$1"

	# Otherwise, use STDIN
	else
		zenity --text-info --editable --title="${title}$2"

	fi
	return $?
}

# Ask to select off of a list
function ui_list {
	local title text list capture

	# NOTE: CASE AND PASTE
	# If a list arguments was specified, use that
	if [[ "$list" ]] ; then
		if [[ "${capture}" == "" ]] ; then
			zenity --list --title="${title}$2" --text="${text}$1" --column="" <<< "$list"
		else
			eval "${capture}=\$(zenity --list --title=\"\${title}\$2\" --text=\"\${text}\$1\" --column=\"\" <<< \"\$list\""
		fi

	# If arguments were specified, use that
	elif [[ $# -gt 0 ]] ; then
		local list
		while [[ $# -gt 0 ]] ; do
			list="$list
$1"
			shift
		done

		if [[ "${capture}" == "" ]] ; then
			zenity --list --title="${title}$2" --text="${text}$1" --column="" <<< "$list"
		else
			eval "${capture}=\$(zenity --list --title=\"\${title}\$2\" --text=\"\${text}\$1\" --column=\"\" <<< \"\$list\""
		fi

	# If a file was specified, use that
	elif [[ "$file" ]] ; then
		if [[ "${capture}" == "" ]] ; then
			zenity --list --title="${title}$2" --text="${text}$1" --column="" < "$file"
		else
			eval "${capture}=\$(zenity --list --title=\"\${title}\$2\" --text=\"\${text}\$1\" --column=\"\" < \"\$file\""
		fi

	# Otherwise, use STDIN
	else
		if [[ "${capture}" == "" ]] ; then
			zenity --list --title="${title}$2" --text="${text}$1" --column=""
		else
			eval "${capture}=\$(zenity --list --title=\"\${title}\$2\" --text=\"\${text}\$1\" --column=\"\""
		fi
	
	fi
	return $?
}

function ui_checkbox {
	log_fatal "Function not yet implemented"
}


function ui_progress {
	log_fatal "Function not yet implemented"
}

