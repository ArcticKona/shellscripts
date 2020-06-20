#!/bin/sh
# Fancy fonts variables for shell. 2020 Arctic Kona. No rights reserved.
# Data from https://misc.flogisoft.com/bash/tip_colors_and_formatting

# Reset all
export FONT_CLEAR=`printf '\e[0m'`

# Fonts
export FONT_BOLD=`printf '\e[1m'`
export FONT_DIM=`printf '\e[2m'`
export FONT_INVERT=`printf '\e[4m'`
export FONT_BLINK=`printf '\e[5m'`
export FONT_LINE=`printf '\e[7m'`
export FONT_HIDE=`printf '\e[8m'`

# Unset fonts
export FONT_UNALL=`printf '\e[21m'`
export FONT_UNBOLD=`printf '\e[22m'`
export FONT_UNDIM=`printf '\e[24m'`
export FONT_UNBLINK=`printf '\e[25m'`
export FONT_UNLINE=`printf '\e[27m'`
export FONT_UNHIDE=`printf '\e[28m'`

# Foregrond colors
export FONT_DEFAULT=`printf '\e[39m'`
export FONT_BLACK=`printf '\e[30m'`
export FONT_RED=`printf '\e[31m'`
export FONT_GREEN=`printf '\e[32m'`
export FONT_YELLOW=`printf '\e[33m'`
export FONT_BLUE=`printf '\e[34m'`
export FONT_MAGENTA=`printf '\e[35m'`
export FONT_CYAN=`printf '\e[36m'`
export FONT_GREY=`printf '\e[37m'`
export FONT_DARKGREY=`printf '\e[90m'`	# D for dark
export FONT_LIGHTRED=`printf '\e[91m'`	# L for light
export FONT_LIGHTGREEN=`printf '\e[92m'`
export FONT_LIGHTYELLOW=`printf '\e[93m'`
export FONT_LIGHTBLUE=`printf '\e[94m'`
export FONT_LIGHTMAGENTA=`printf '\e[95m'`
export FONT_LIGHTCYAN=`printf '\e[96m'`
export FONT_WHITE=`printf '\e[97m'`

# Background colors
export FONT_BACKDEFAULT=`printf '\e[49m'`
export FONT_BACKBLACK=`printf '\e[40m'`
export FONT_BACKRED=`printf '\e[41m'`
export FONT_BACKGREEN=`printf '\e[42m'`
export FONT_BACKYELLOW=`printf '\e[43m'`
export FONT_BACKBLUE=`printf '\e[44m'`
export FONT_BACKMAGENTA=`printf '\e[45m'`
export FONT_BACKCYAN=`printf '\e[46m'`
export FONT_BACKGREY=`printf '\e[47m'`
export FONT_BACKDARKGREY=`printf '\e[100m'`
export FONT_BACKLIGHTRED=`printf '\e[101m'`
export FONT_BACKLIGHTGREEN=`printf '\e[102m'`
export FONT_BACKLIGHTYELLOW=`printf '\e[103m'`
export FONT_BACKLIGHTBLUE=`printf '\e[104m'`
export FONT_BACKLIGHTMAGENTA=`printf '\e[105m'`
export FONT_BACKLIGHTCYAN=`printf '\e[106m'`
export FONT_BACKWHITE=`printf '\e[107m'`


