#!/bin/bash
# Simple filesystem abstraction layer
import sys/cat
FSIO_ROOT=.
FSIO_SELF=fsio
FSIO_FDSI=4

function fsio_activate {

function fsio_create {
	local path

	if [[ $path ]] ; then
		true 1> "$FSIO_ROOT/$path"
	else
		true 1> "$FSIO_ROOT/$1"
	fi

	return $?
}

function fsio_read {
	local path

	if [[ $path ]] ; then
		cat "$FSIO_ROOT/$path"
	else
		cat "$FSIO_ROOT/$1"
	fi

	return $?
}

function fsio_write {
	local path content
	if [[ $content ]] ; then
		printf "%s" "$content" | \
			path=$path fsio_append
		return $?
	fi

	if [[ $path ]] ; then
		cat - 1> "$FSIO_ROOT/$path"
	else
		cat - 1> "$FSIO_ROOT/$1"
	fi

	return $?
}

function fsio_append {
	local path content
	if [[ $content ]] ; then
		printf "%s" "$content" | \
			path=$path fsio_append
		return $?
	fi

	if [[ $path ]] ; then
		cat - >> "$FSIO_ROOT/$path"
	else
		cat - >> "$FSIO_ROOT/$1"
	fi

	return $?
}

function fsio_mkdir {
	local path

	while [[ $# -gt 0 ]] ; do
		mkdir "$FSIO_ROOT/$1" ||
			return $?
		shift
	done
	[[ $path ]] &&
		mkdir "$FSIO_ROOT/$path"

	return $?
}

function fsio_list {
	local capture path IFS=
	if [[ "$capture" ]] ; then
		eval "$capture=\$( path=\$path fsio_list \$@ )"
		return $?
	fi

	[[ $# -eq 0 ]] && [[ ! $path ]] &&
		ls "$FSIO_ROOT"
	while [[ $# -gt 0 ]] ; do
		ls "$FSIO_ROOT/$1" ||
			return $?
		shift
	done
	[[ $path ]] &&
		ls "$FSIO_ROOT/$path"

	return $?
}

function fsio_delete {
	local path

	while [[ $# -gt 0 ]] ; do
		rm -rf "$FSIO_ROOT/$1" ||
			return $?
		shift
	done
	[[ $path ]] &&
		rm -rf "$FSIO_ROOT/$path"

	return $?
}

}

fsio_activate


