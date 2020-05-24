#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import check/
import misc/default
import ui/zenity
import ui/dialog
import ui/cli
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
	local title text list file line

	while [[ $# -gt 0 ]] ; do
		list="$1
$list"
		shift
	done
	[[ "$file" ]] &&
		list="$( cat $file )
$list"

	if [[ "$list" ]] ; then
		if [[ "$capture" ]] ; then
			eval "$capture=\$( $UI_API <<< \$list )"
		else
			$UI_API <<< "$list"
		fi
	else
		if [[ "$capture" ]] ; then
			eval "$capture=\$( $UI_API )"
		else
			$UI_API
		fi
	fi
	
	return $?
}

# If DISPLAY is set and zenity is installed, use zenity
if [[ "$DISPLAY" ]] && check_command zenity ; then
	alias ui_info="UI_API=ui_zenity_info ui_info"
	alias ui_warn="UI_API=ui_zenity_warn ui_warn"
	alias ui_text="UI_API=ui_zenity_text ui_text"
	alias ui_entry="UI_API=ui_zenity_entry ui_entry"
	alias ui_edit="UI_API=ui_zenity_edit ui_edit"
	alias ui_list="UI_API=ui_zenity_list ui_list"

# TODO: Use dialog

# Finally, use CLI
else
	alias ui_info="UI_API=ui_cli_info ui_info"
	alias ui_warn="UI_API=ui_cli_warn ui_warn"
	alias ui_text="UI_API=ui_cli_text ui_text"
	alias ui_entry="UI_API=ui_cli_entry ui_entry"
	alias ui_edit="UI_API=ui_cli_edit ui_edit"
	alias ui_list="UI_API=ui_cli_list ui_list"

fi


