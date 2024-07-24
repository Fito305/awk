# Check for Readable Datafiles
# Normally, if you give awk a datafile that isn't readable, it stops with a fatal error. There are 
# times when you might want to just ignore such files and keep going. You can do this by
# prepending the following program to your awk program:

# readable.awk --- linbrary file to skip over unreadable files
BEGIN {
    for (i = 1; i < ARGC; i++) {
        if (ARGV[i] ~ /^[a-zA-Z_][a-zA-Z0-9_]*=.*/ \
            || ARGV[i] == "-" || ARGV[i] == "/dev/stdin")
            continue    # assignment or standard input
        else if ((getline junk < ARGV[i]) < 0) # unreadable
            delete ARGV[i]
        else 
            close(ARGV[i])
    }
}

# This works, because the getline won't be fatal. Removing the element from ARGV
# with delete skips the file (because it's no longer in the list).

