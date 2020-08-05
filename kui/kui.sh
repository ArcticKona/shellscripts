#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import check/system
import misc/default
import kui/zenity
import kui/dialog
import kui/cli
UI_API="log_fatal"

function ui_info {
	local title text
	default text="$1" && shift
	default title="$1" && shift

	if [[ "$capture" ]] ; then
		eval "$capture=\$( $UI_API )"
	else
		$UI_API
	fi

	return $?
}

function ui_warn {
	local title text
	default text="$1" && shift
	default title="$1" && shift

	if [[ "$capture" ]] ; then
		eval "$capture=\$( $UI_API )"
	else
		$UI_API
	fi

	return $?
}

function ui_text {
	local title text file
	default file="$1" && shift
	default title="$1" && shift

	if [[ "$capture" ]] ; then
		eval "$capture=\$( $UI_API )"
	else
		$UI_API
	fi

	return $?
}

function ui_entry {
	local title text entry
	default text="$1" && shift
	default title="$1" && shift
	default entry="$1" && shift

	if [[ "$capture" ]] ; then
		eval "$capture=\$( $UI_API )"
	else
		$UI_API
	fi

	return $?
}

function ui_edit {
	local title text file
	default file="$1" && shift
	default text="$1" && shift
	default title="$1" && shift

	if [[ "$capture" ]] ; then
		eval "$capture=\$( $UI_API )"
	else
		$UI_API
	fi

	return $?
}

function ui_list {
	local title text list file line IFS="
"

	# Get arugments
	while [[ $# -gt 0 ]] ; do
		list="$list
$1"
		shift
	done
	[[ "$file" ]] &&
		list="$list
$( cat $file )"
	[[ "$list" ]] ||
		list=$( cat - )

	# Remove empty lines
	file=""
	for line in $list ; do
		if [[ "$file" ]] ; then
			[[ "$line" ]] &&
				file="$file
$line"
		else
			[[ "$line" ]] &&
				file="$line"
		fi
	done
	list="$file"

	# Ok
	if [[ "$capture" ]] ; then
		eval "$capture=\$( $UI_API )"
	else
		$UI_API
	fi
	
	return $?
}

# If DISPLAY is set and zenity is installed, use zenity
if [[ "$DISPLAY" ]] && check_command zenity ; then
	function kui_info {
		local IFS=
		UI_API=ui_zenity_info ui_info $@
		return $?
	}
	function kui_warn {
		local IFS=
		UI_API=ui_zenity_warn ui_warn $@
		return $?
	}
	function kui_text {
		local IFS=
		UI_API=ui_zenity_text ui_text $@
		return $?
	}
	function kui_entry {
		local IFS=
		UI_API=ui_zenity_entry ui_entry $@
		return $?
	}
	function kui_edit {
		local IFS=
		UI_API=ui_zenity_edit ui_edit $@
		return $?
	}
	function kui_list {
		local IFS=
		UI_API=ui_zenity_list ui_list $@
		return $?
	}

# TODO: Use dialog

# Finally, use CLI
else
	function kui_info {
		local IFS=
		UI_API=ui_cli_info ui_info $@
		return $?
	}
	function kui_warn {
		local IFS=
		UI_API=ui_cli_warn ui_warn $@
		return $?
	}
	function kui_text {
		local IFS=
		UI_API=ui_cli_text ui_text $@
		return $?
	}
	function kui_entry {
		local IFS=
		UI_API=ui_cli_entry ui_entry $@
		return $?
	}
	function kui_edit {
		local IFS=
		UI_API=ui_cli_edit ui_edit $@
		return $?
	}
	function kui_list {
		local IFS=
		UI_API=ui_cli_list ui_list $@
		return $?
	}

fi


