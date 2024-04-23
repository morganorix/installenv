#!/bin/bash
# URL : https://gist.github.com/ppacher/4d51323d7acd5ce89af202076d086aba

pretty() {
    prefix=$1

    # a named pipe can be unlinked as soon as it has been attached to some file descriptor
    # this allows to create anonymous pipes

	# create a temporary named pipe
	PIPE=$(mktemp -u)
	mkfifo $PIPE
	# attach it to file descriptor 3
	exec 3<>$PIPE
	# unlink the named pipe
	rm $PIPE

	PIPE=$(mktemp -u)
	mkfifo $PIPE
	exec 4<>$PIPE
	rm $PIPE

    	# now we have two additional file descriptors available which we can use 
    	# to pipe stdout and stderr of the target command
    	# due to file handle inheritance, we can simple access fd 3 and fd 4 in child 
    	# processes

    	# first subshell to supress job control messages
    	# this actually starts a sub process but thankfully we inherited the file descriptors 3 and 4
    	(
        	# launch background polling job for stdout
        	(
            		while read line ; do
                		printf '\e[32;1m%-10s |\033[0;90m %s\n' "$prefix" "$line"
            		done <&3 # FD 3 is inherited by both parent processes
        	) &
    	)


    	(
        	# launch background polling job for stderr
        	(
            		while read line ; do
                    		printf '\e[31;1m%-10s |\033[0;90m %s\n' "$prefix" "$line" >&2 # prefix/colorize stderr and write 
											 # it to parents stderr
            		done <&4
        	) &
    	)

	$@ >&3 2>&4

	# close the file descriptor when we are finished
    	# this causes both while loops to exit (input closed)
	exec 3>&-
	exec 4>&-

    	# print a final newline
    	#echo ""
}

# cat << EOT
# Example usage

# source ./pretty.sh
# pretty sudo apt-get update
# EOT
