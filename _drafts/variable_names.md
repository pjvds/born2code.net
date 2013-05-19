## Variable names

The name of a variable can contain only letters (a to z or A to Z), numbers (0 to 9) or the underscore 
character (_). In addition, a variable's name can start only with a letter or an underscore. 

The following examples are valid variable names: 

    _WERCKER
    WERCKER_SOURCE_DIR
    TRUST_NO_1
    TWO_TIMES_2 
	
## Writing output

The following functions are available to write output:

`success` - writes a success message.

`fail` - writes a failure message and stops execution.

`warn` - writes a warning message.

`info` - writes a informational message.

`debug` - writes a debug message.

Here is a short example:

	debug "checking if config exists…"
	if [ -e ".config" ]
	then
		info ".config file found"
	else
		fail "missing .config file"
	fi
	
## Check if a variable is set and not empty

	if [ ! -n "$var" ] ; then
		echo "var is not set or value is empty"
	fi
	
Where `$var` is the variable you want to check.
	
## Check if command exists

	if ! type s3cmd &> /dev/null
	then
		echo "s3cmd exists!"
	else
		echo "s3cmd does not exist!"
	fi
	
Where `s3cmd` is the command you want to check. The `&> /dev/null` part makes it silence (it generates no output).