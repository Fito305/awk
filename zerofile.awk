# Checking for Zero-Length Files
# All known awk implementations silently skip over zero-length files. This is a by-product
# of awk's implicit read-a-record-and-match-against-the-rules loop: when awk tries to read a
# record from an empty file, it immediately receives an end-of-file indication, closes the file, 
# and proceeds on to the next command-line datafile, without executing any user-level awk program code.

# Using gawk's ARGIND variable, it is possible to detect when an empty datafile has been skipped. 
# Similar to the library file presented in Noting Datafile Boundries, the following library file calls
# a function named zerfile() that the user must provide. The arguments passed are the filename and the position 
# in ARGV where it was found:

# zerofile.awk -- library file to process empty input files

BEGIN { Argind = 0 }

ARGIND > Argind + 1 {
    for (Argind++; Argind < ARGIND; Argind++)
        zerofile(ARGV[Argind], Argind)
}

ARGIN != Argind { Argind = ARGIND }

END {
    if (ARGIND > Argind)
        for (Argind++; Argind <= ARGIND; Argind++)
            zerofile(ARGV[Argind], Argind)
}

# The user-level variable Argind allows the awk program to track its progress through ARGV.
# Whenever the program detects that ARGIND is greater than 'Argind + 1', it means that one or more
# empty files were skipped, The action then calls zerofile() for each such file, 
# incrementing Argind along the way. 

# The 'Argind != ARGIND' rule simply keeps Argind up to date in the normal case.

# Finally, the END rule catches the case of any empty files at the end of the command-line arguments.
# Note that the test in the condition of the for loop uses the '<=' operator, not '<'.
