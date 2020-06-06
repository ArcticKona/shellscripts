#!/bin/bash
# Simple key value database
import misc/default
import log/log
default ADB_ROOT="$HOME/kona/adb"
mkdir -p "$ADB_ROOT"
log_warn "WARNING: ADB is very slow!"

# Creates a new database object
function adb_new {
	local name capture
	default name=$1 && shift
	default capture=$1
	default capture=$name
	alias ${capture}_read="name=\"$name\" adb_read"
	alias ${capture}_add="name=\"$name\" adb_add"
	alias ${capture}_filter="name=\"$name\" adb_filter"
	alias ${capture}_get="name=\"$name\" exec=adb_get_get adb_filter"
	alias ${capture}_less="name=\"$name\" exec=adb_less_less adb_filter"
	alias ${capture}_more="name=\"$name\" exec=adb_more_more adb_filter"
	alias ${capture}_delete="name=\"$name\" exec=adb_delete_delete adb_filter"
	alias ${capture}_format="name=\"$name\" adb_format"
	return 0
}

# Outputs all records
function adb_read {
	local name
	[[ "$name" ]] &&
		name="$ADB_ROOT/$name"

	cat $name
	return $?
}

function adb_write {
	local name
	name="$ADB_ROOT/$name"
	cat - 1> $name
	return $?
}

# Adds a new record
function adb_add {
	local name IFS

	if [[ "$name" ]] ; then
		IFS=""
		true | adb_add $@ >> "$ADB_ROOT/$name"

	else
		cat -
		printf "\\30%s" "$1"
		shift
		while [[ $# -gt 0 ]] ; do
			printf "\\31%s" "$1"
			shift
		done
	fi
	
	return 0
}

# Finds records that match any
function adb_filter {
	local name exec IFS line unit argv
	if [[ $name ]] ; then
		name="$ADB_ROOT/$name"
		IFS=
		unit=$( name= exec=$exec adb_filter $@ < "$name" ) &&
		printf "%s" "$unit" 1> "$name"
		return $?
	fi
	default exec=$1 && shift

	IFS=$( printf "\\30" )
	for line in $( cat - ) ; do
		IFS=$( printf "\\31" )
		for unit in $line ; do
			IFS=""
			for argv in $@ ; do
				if [[ ${unit%%:*} == ${argv%%:*} ]]; then
					if key=${unit%%:*} value=${unit#*:} argv=${argv#*:} $exec ; then
						printf "\\30%s" $line
						continue 3
					fi
				fi
			done
		done
	done	
}

# Selects records matching, all
function adb_get_get {
	[[ "$value" == "$argv" ]] &&
		return 0 ||
		return 1
}
alias adb_get="exec=adb_get_get adb_filter"

# Selects records, only less
function adb_less_less	 {
	if [[ "$value" -le "$argv" ]] ; then
		return 0
	elif ! [[ "$value" -gt "$argv" ]] ; then
		if [[ "$value" < "$argv" ]] || [[ "$value" == "$argv" ]] ; then
			return 0
		fi
	fi
	return 1
}
alias adb_less="exec=adb_less_less adb_filter"

# Selects records, only more
function adb_more_more {
	if [[ "$value" -ge "$argv" ]] ; then
		return 0
	elif ! [[ "$value" -lt "$argv" ]] ; then
		if [[ "$value" > "$argv" ]] || [[ "$value" == "$argv" ]] ; then
			return 0
		fi
	fi
	return 1
}
alias adb_more="exec=adb_more_more adb_filter"

# Deletes a record
function adb_delete_delete {
	[[ "$value" == "$argv" ]] &&
		return 1 ||
		return 0
}
alias adb_delete="exec=adb_delete_delete adb_filter"

# Formats output
function adb_format {
	local name exec IFS line unit argv
	if [[ $name ]] ; then
		name="$ADB_ROOT/$name"
		IFS=
		name= exec=$exec adb_format $@ < "$name"
		return $?
	fi

	IFS=$( printf "\\30" )
	for line in $( cat - ) ; do
		[[ $line ]] ||
			continue
		IFS=
		for argv in $@ ; do
			if [[ ${argv:0:1} == ">" ]] ; then
				IFS=$( printf "\\31" )
				for unit in $line ; do
					IFS=""
					if [[ ${unit%%:*} == ${argv:1} ]]; then
						printf "%s" ${unit#*:}
						continue 2
					fi
				done
			else
				printf $argv
			fi
		done
	done

	return 0
}


