#!/bin/bash
# Null
import system/mktemp

function null {
	while read ; do
		true ; done
	return 0
}

[[ -e /dev/null ]] &&
	NULL=/dev/null ||
	NULL=$( mktemp )


