#!/bin/bash
# Simple filesystem abstraction layer TODO: finish
FSIO_ROOT=/
FSIO_SELF=fsio
FSIO_FDSI=4

function fsio_new {
	
}

function fsio_create {
	
}

function fsio_read {
	
}

function fsio_write {

}

function fsio_append {
	
}

function fsio_mkdir {
	if [[ $1 ]] ; then
		mkdir "$FSIO_ROOT/$1"
	else
		mkdir "$FSIO_ROOT/$path"
	fi
	return $?
}

function fsio_list {
	local capture
	if [[ "$capture" ]] ; then
		eval "$capture=\$( $0 $1 )"
		return $?
	fi

	if [[ $1 ]] ; then
		ls "$FSIO_ROOT/$1"
	else
		ls "$FSIO_ROOT/$path"
	fi
	return $?
}

function fsio_delete {
	if [[ $1 ]] ; then
		rm -rf "$FSIO_ROOT/$1"
	else
		rm -rf "$FSIO_ROOT/$path"
	fi
	return $?
}


