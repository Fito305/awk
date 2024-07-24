## The following program, awksed.awk, accepts at least two command-line
# arguments: the pattern to look for and the text to replace it with.
# Any additional arguments are treated as datafile names to process.
# If none are provided, the standard input is used:

# awksed.awk --- do s/foo/bar/g  using just print

function usage()
{
    print "usage: awksed pat repl [files..]" > "dev/stderr"
    exit 1
}

BEGIN {
    # validate arguments
    if (ARGC < 3)
        usage()

    RS = ARGV[1]
    ORS = ARGV[2]

    # don't use arguments as files
    ARGV[1] = ARGV[2] = ""
}

# look ma, no hands!
{
    if (RT == "")
        printf "%s", $0
    else 
        print
}

## The program relies on gawk's ability to have RS be a regexp, as well as on
# the setting of RT to the actual text that terminates the record.

# The idea is to have RS be the pattern to look for. gawk automatically sets $0 to the text
# between matches of the pattern. This is text that we want to keep, unmodified. Then,
# by setting ORS to the replacement text, a simple print statement outputs the text
# we want to keep, followed by the replacement text.

# There is one wrinkle to this scheme, which is what to do if the last record doesn't 
# end with text that matches RS. Using a print statement unconditionally prints the 
# replacement text, which is not correct. However, if the file did not end in text that matches
# RS, RT is set to the null string. In this case, we can print $0 using printf.

## The BEGIN rule handles the setup, checking for the right number of arguments and calling
# usage() if there is a problem. Then it sets RS and ORS from the command-line arguments and 
# sets ARGV[1] and ARGV[2] to the null string, so that they are not treated as 
# filenames. 

# The usage() funciton prints an error message and exits. Finally, the single rule handles the 
# printing scheme outline earlier, using print or printf as appropriate, depending upon the 
# value of RT.
