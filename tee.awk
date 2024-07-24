## Duplicating Output into Multiple Files
# The tee program is known as a "pipe fitting". tee copies its standard input to its 
# standard output and also duplicates it to the files named on the command line. Its
# usage is as follows:
#       tee [-a] file ...

# The -a option tells tee to append to the named files, instead of truncating them and
# starting over.
#
# The BEGIN rule first makes a copy of all the command line arguments into an array named copy. 
# ARGV[0] is not needed, so it is not copied. tee cannot use ARGV directly, because awk attempt
# to process each filename in ARGV as input data.
#
# The first argument is -a, then the flag variable append is set to true, and both ARGV[1]
# and copy[1] are deleted. If ARGC is less than two, then no filenames were supplied and tee
# prints a usage message and exits. Finally, awk is forced to read the standard input by
# setting ARGV[1] to "-" and ARGC to two:

# tee.awk --- tee in awk
#
# Copy standard input to all named output files.
# Append content if -a option is supplied.
#
BEGIN {
    for (i = 1; i < ARGC; i++)
        copy[i] = ARGV[i]

    if (ARGV[1] == "-a") {
        append = 1
        delete ARGV[1]
        delete copy[1]
        ARGC--
    }
    if (ARGC < 2) {
        print "usage: tee [-a] file..." > "/dev/stderr"
        exit 1
    }
    ARGV[1] = "-"
    ARGC = 2
}

## The follwoing single rule does all the work. Because there is not pattern, it is executed for each line of input. The body of the rule 
# simply prints the line into each file on the command line, and then to the standard output:

{
    # moving the if outside the loop makes it run faster
    if (append)
        for (i in copy)
        print >> copy[i]
    else
        for (i in copy)
        print > copy[i]
    print
}

# It is also possible to write the loop this way:
# for (i in copy)
#   if (append)
#       print >> copy[i]
#   else 
#       print > copy[i]


## Finally, the END rule cleans up by closing all the output files:
END {
    for (i in copy)
        close(copy[i])
}
