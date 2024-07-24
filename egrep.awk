### The program begins with a descriptive comment and then a BEGIN rule that processes the command-line
# arguments with getopt(). The -i (ignore case) option is particularly easy with gawk; we just use the IGNORECASE 
# predefined variable:

# egrep.awk --- simulate egrep in awk
#
# Options:
#   -c  count of line
#   -s  silent - use exit value
#   -v  invert test, success if no match
#   -i  ignore case
#   -l  print filenames only
#   -e  argument is pattern
#
#   Requires getopt and file transition library functions

## The use of ARGC and ARGV signify the need to use gawk. 
# These predefined variables are specific to gawk.

BEGIN {
    while ((c = getopt(ARGC, ARGV, "ce:svil")) != -1) {
        if ( c == "c")
            count_only++
        else if (c == "s")
            no_print++
        else if (c == "v")
            invert++
        else if (c == "i")
            IGNORECASE = 1
        else if (c == "l")
            filenames_only++
        else if (c == "e")
            pattern = Optarg
        else
            usage()
    }

    ### Next comes the code that handles the egrep-specific behavior. If no pattern is 
    # supplied with -e, the first nonoption on the command line is used. The awk command-line 
    # arguments up to ARGV[Opting] are cleared, so that awk won't try to process them as files.
    # If no files are specified, the standard input is used, and if multiple files are specified, 
    # we make sure to note this so that the filenames can precede the match lines in the output:

    if (pattern == "")
        pattern = ARGV[Optind++]

    for (i = 1; i < Optind; i++)
        ARGV[i] = ""
    if (Optind >= ARGC) {
        ARGV[1] = "-"
        ARGC = 2
    } else if (ARGC - optind > 1)
        do_filenames++

    # if (IGNORECASE)
        # pattern = tolower(pattern)
}

## The last wo lines are commented out, as they are not needed in gawk. They should be
# uncommented if you have to use another version of awk.

# The next set of lines should be uncommented if you are not using gawk. This rule 
# translates all the characters in the input line into lowercase if the -i option is specified. 
# The rule is commented out as it is not necessary with gawk:

# {
#   if (IGNORECASE)
#       $0 = tolower($0)
# }

## The endfile() function is called after each file has been processed. It affects the output
# only when the user wants a count of the number of lines that matched. no_print is true only
# if the exit status is desired. count_only is true if line counts are desired. egrep 
# therefore only prints line counts if printing and counting are enabled. The output format
# must be adjusted depending upon the number of files to process. Finally, fcount is added 
# to total, so that we know the total number of lines that matched the pattern:

function endfile(file)
{
    if (! no_print && count_only) {
        print file ":" fcount
    else
        print fcount
    }

    total += fcount
}

########################### This makes the program gawk specific:
{
    matches = ($0 ~ pattern)
    if (invert)
        matches = ! matches

    fcount += matches  # 1 or 0

    if (! matches)
        next

    if (! count_only) {
        if (no_print)
            nextfile

        if (filenames_only) {
            print FILENAME
            nextfile
        }

        if (do_filenames)
            print FILENAME ":" $0
        else 
            print
    }
}

## The END rule takes care of producing the correct exit status. If there are no matches, the
# exit status is one; otherwise, it is zero:
END {
    exit (total == 0)
}

## The usage(0 function prints a usage message in case of invalid options, and the exits:
function usage()
{
    print("Usage: egrep [-csvil] [-e pat] [files...]") > "/dev/stderr"
    print("\n\tegrep [-csvil] pat [files...]") > "/dev/stderr"
    exit 1
}
