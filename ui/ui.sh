#!/bin/bash
# Simple User Interface API. Copyright (c) 2020 Arctic Kona. No Rights Reserved.
import misc/check

# If DISPLAY is set and zenity is installed, use zenity
if [[ "$DISPLAY" ]] && chk_cmd zenity 1> /dev/null ; then
	import "ui/zenity"

# Otherwise, if dialog is installed, use it
#elif chk_cmd dialog ; then
#	import "ui/dialog"

# Finally, use CLI
else
	import "ui/cli"

fi


