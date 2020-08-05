# Simple BASH exceptions. 2020 Kona Arctic.
import log/log

# For technical reasons manually return
function throw {
	rtn=$?
	[[ $rtn -gt 0 ]] &&
		rtn=1
	local error

	# If there's a catcher record exception
	if [[ $EXCEPT_catch -gt 0 ]] ; then
		EXCEPT_except="$error"
		return $rtn

	# Or make fatal
	else
		log_fatal "$error"

	fi
}
alias throw="throw ; return \$? ;"

function catch {

	# Stack a catcher
	EXCEPT_catch=$(( $EXCEPT_catch + 1 ))

	# Execute
	IFS= $@
	rtn=$?

	# Unstack
	EXCEPT_catch=$(( $EXCEPT_catch - 1 ))
	
	return $rtn
}

function except {
	[[ $? -gt 0 ]] &&
		IFS= $@ $EXCEPT_except
	return $?
}


