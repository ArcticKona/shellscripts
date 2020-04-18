#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import misc/check

# If DISPLAY is set and zenity is installed, use zenity
if [[ "$DISPLAY" ]] && check_command zenity 1> /dev/null ; then
	IMPORT_CHECK=no import "ui/zenity"

# Otherwise, if dialog is installed, use it
#elif check_command dialog ; then
#	IMPORT_CHECK=no import "ui/dialog"

# Finally, use CLI
else
	IMPORT_CHECK=no import "ui/cli"

fi


