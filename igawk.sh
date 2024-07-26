#! /bin/sh
# igawk.sh --- like gawk but do @include processing 

if [ "$1" = debug]
then 
    set -x
    shift
fi

# A literal newline, so that program text is formatted correctly
n='
'

# Initialize variables to empty
program=
opts=

while [ $# -ne 0 ] # loop over arguments
do 
    case $1 in
        --) shift
            break ;;

        -W) shift
            # The ${x?'message here'} construct prints a
            # diagnostic if $x is the null string
            set --W"${@?'missing operand'}"
            continue ;;

        -[vF]) opts="$opts $1 '${2?'mising operand'}'"
            shift ;;

        -[vF]*) opts="$opts '$1'" ;;

        -f) program="$program$n@include ${2?'missing operand'}"
            shift ;;

        -f*) f=$(expr "$1" : '-f\(.*\)')
            program="$program$n@include $f" ;;

        -[W-]file=*)
            f=$(expr "$1" : '-.file=\(.*\)')
            program="$program$n@include $f" ;;

        -[W-]file)
            program="$program$n@include ${2?'missing operand'}"
            shift ;;

        -[W-]source=*)
            t=$(expr "$1" : '-.source=\(.*\)')
            program="$program$n$t" ;;

        -[W-]source)
            program="$program$n${2?'missing  operand'}"
            shift ;;

        -[W-]version)
            echo igawk: version 3.0 1>&2
            gawk --version
            exit 0 ;;

        -[W-]*) opts="$opts '$1'" ;;

        *)      break ;;
    esac
    shift
done

if [ -z "$program" ]
then 
    program=${1?'missing program'}
    shift
fi

# At this point, `program' has the program.




## This program simulates gawk's searching of the `AWKPATH` variable
# and also allows nested includes (i.e., a file that is included with
# @include can contain further @include statements). igawk makes an effort to only include
# files once, so that nested includes don't accidentally include a library function twice. 

# igawk should behave just like gawk externally. This means it should accept all of gawk's 
# command line arguments, including the ability to have multiple source files
# specified via `-f` and the ability to mix command-line and library source files.

# The program is written using the POSIX Shell (sh) command language. It works as follows:
# 1. Loop through the arguments, saving anything that doesn't represent awk source code
# for later, when the expanded program is run.
# 2. For any arguments that do represent awk text, put the arguments into a shell variable
# that will be expanded. There are two cases:
#       a. Literal text, provided wit `-e` or `--source`. This text is just appended directly.
#       b. Sourse filenames, provided with `-f`. We ise a neat trick and append '@include filename'
#       to the shell variable's contents. Because the file-inclusion program works the way gawk 
#       does, this gets the text of the file included in the program at the correct point.
# 3. Run an awk program (naturally) over the shell variable's contents to expand
# @include statements. The expanded program is placed in a second shell variable. 
# 4. Run the expanded program with gawk and any other original command-line arguments
# that the user supplied (such as datafile names).

# This program uses shell variables extensively: for storing command-line arguments and the text
# of the awk program that will expand the user’s program, for the user’s original program, and for
# the expanded program. Doing so removes some potential problems that might arise were we to use temporary
# files instead, at the cost of making the script somewhat more complicated.

# The initial part of the program turns on shell tracing if the first argument is ‘debug’.
# The next part loops through all the command-line arguments. There are several cases of
# interest:

# --
# This ends the arguments to igawk. Anything else should be passed on to the user's awk program
# without being evaluated.

# -W 
# This indicates that the next option is specific to gawk. To make argument processing
# easier, the -W is appended to the front of the remaining arguments and the loop continues.
# (This is an POSIX Shell (sh) programming trick.)

# -v -F
# These are saved and passed on to gawk.

# -f, --file, --file=, -Wfile=
# The filename is appended to the shell variable program with an @include statement. 
# The expr utility is used to remove the leading option part of the argument (e.g., ‘-- file=’).
# (Typical sh usage would be to use the echo and sed utilities to do this work. Unfortunately, some
# versions of echo evaluate escape sequences in their arguments, possibly mangling the program text.
# Using expr avoids this problem.)

# --source, --source=, -Wsource=
# The source text is appended to program.

# --version, -Wversion
# igawkprintsitsversionnumber,runs‘gawk --version’togetthegawkversion
# information, and then exits.

# If none of the -f, --file, -Wfile, --source, or -Wsource arguments are supplied,
# then the first nonoption argument should be the awk program. If there are no command-line 
# arguments left, igawk prints an error message and exits. Otherwise, the first argument is appended 
# to program. In any case, after the arguments have been processed, the shell variable program contains 
# the complete text of the original awk program.
