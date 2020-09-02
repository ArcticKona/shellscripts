#!/bin/bash
# Sorts STDIN. 2020 Kona Arctic. Some rights reserved.
#import misc/check

if check_command sort ; then
	function sort {
		$( which sort - )
		return $?
	}

# Simple insertion sort. Very inefficient beyond small input. TODO: Better algorithm
else
	function sort {
		local sort push read line done IFS="
"

		while read read ; do
			push=
			done=
			for line in $sort ; do
				if [[ ! $done ]] && [[ $read < $line ]] ; then
					push="$push
$read"
					done=1
				fi
				push="$push
$line"
			done
			[[ $done ]] ||
				push="$push
$read"
			sort=$push
		done

		cat - <<< $sort
		return 0
	}

fi


