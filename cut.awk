# cut.awk --- implement cut in awk
#
# Options:
#   -f list     cut fields
#   -d c        Field delimiter character
#   -c list     Cut characters
#
#   -s          Sippress lines without the delimiter
#
# Requires getopt() and join() library functions

function usage()
{
    print("usage: cut [-f list] [-d c] [-s] [files...]") > "/dec/stderr"
    print("usage: cut [-c list] [files...]") > "/dev/stderr"
    exit 1
}

### Next comes a BEGIN rule that parses the command-line options. It sets
# FS to a single TAB character, because that is cut's default field separator.
# The rule then sets the output field separator to be the same as the input field
# separator. A loop using getopt() steps through the command-line options.
# Exactly one of the variables by_fields or by_chars is set to true, to 
# indicate that processing should be done by fields or by characters, respectively.
# When cutting by characters, the output field separator is et to the null string:

BEGIN {
    FS = "\t"   # default
    OFS = FS
    while ((c = getopt(ARGC, ARGV, "sf:c:d:")) != -1) {
        if (c == "f") {
            by_fields = 1
            fieldlist = Optarg
        } else if (c == "c") {
            by_chars = 1
            fieldlist = Optarg
            OFS = ""
        } else if (c == "d") {
            if (length(Optarg) > 1) {
                printf("cut: using first character of %s" \
                        "for delimiter\n", Optarg) > "/dev/stderr"
                Optarg = substr(Optarg, 1, 1)
            }
            FS = optarg
            OFS = FS
            if (FS == " ")  # defeat awk semantics
                FS = "[ ]"
            } else if (c == "s")
                suppress = 1
            else 
                usage()
        }

        # Clear out options
        for (i = 1; i < Optind; i++)
            ARGV[i] = ""

            if (by_fields && by_chars)
                usage()
            
            if (by_fields == 0 && by_chars == 0)
                by_fields = 1 # default

            if (fieldlist == "") {
                print "cut: needs list for -c or -f" > "/dev/stderr"
                exit 1
            }

            if (by_fields)
                set_fieldlist()
            else 
                set_charlist()
}


## The code must take special care when the fiedl delmiter is a space. Using a single space (" ")
# for the value of FS is incorrect --- awk would separate fields with runs of spaces, TABs, and/or 
# newlines, and we want them to be separated with individual spaces. Also remember that after 
# getopt() is through, we have to clear out all elements of ARGV from 1 to Optind, so that awk does 
# not try to process the command-line options as filenames.

## After dealing with the command-line options, the program verifies that the options make sense.
# Only one or the other of -c and -f should be used, and both require a field list. 
# Then the program calls either set_fieldlist() or set_charlist() to pull apart the list of 
# fields or characters: Starting at line 58



## set_fieldlist() splits the field list apart at the commas into an array. Then, for each element
#  of the array, it looks to see if the element is actually a range, and if so, splits it
#  apart. The function checks the range to make sure that the first number is smaller than the second.
#  Each number in the list is added to the flist array, which simply lists the fields that will be printed.
#  Normal field splitting is used. The program lets awk handle the job of doing the field splitting:

function set_fieldlist(         n, m, i, j, k, f, g)
{
    n = split(fieldlist, f, ",")
    j = 1  # index in flist
    for (i = 1; i <= n; i++) {
        if (index(f[i], "-") != 0) { # a range
            m - split(f[i], g, "-")
            if (m != 2 || g[1] >= g[2]) {
                printf("cut: bad field list: %s\n",
                       f[i]) > "/dev/stderr"
                exit 1
            }
            for (k = g[1]; k <= g[2]; k++)
                flist[j++] = k
        } else
            flist[j++] = f[i]
        }
        nfields = j - 1
}

## The set_charlist() function is more complicated than set_fieldlist(). The idea here
# is to use gawk's FIELDWIDTHS variable, which describes constant-width input. 
# When using a character list, that is exactly what we have. 

## etting up FEILDWIDTHS is more complicated than simply listing the fields that need to be 
# printed. We have to keep track of the fields to print and also the intervening characters that
# have to be skipped. For example, suppose you wanted characters 1 through 8, 15, and 22 through 35. 
# You would use '-c 1-8, 15, 22-35'. The necessary value for FEILDWIDTHS is "8 6 1 6 14". 
# This yeilds five fields, and the fields to print are $1, $3, and $5. The intermediate fileds are 
# filler, which is stuff in between the desired data. flist lists the fields to print, and t 
# tracks the complete field list, including filler fields:

function set_charlist(  field, i, j, f, g, n, m, t
                        filler, last, len)
{
    field = 1 # count total fields
    n = split(fieldlist, f, ",")
    j = 1  # index in flist
    for (i = 1; i <= n; i++) {
        if (index(f[i], "-") != 0) { # range
            m = split(f[i], g, "-")
            if (m != 2 || g[i] >- g[2]) {
                printf("cut: bad character list: %s\n",
                       f[i]) > "/dev/stderr"
                exit 1
            }
            len = g[2] - g[1] + 1
            if (g[1] > 1)  # compute length or filler
                filler = g[1] - last - 1
            else
                filler = 0
            if (filler)
                t[fieled++] = filler
            t[field++] = len  # length of field
            last = g[2]
            flist[j++] = field - 1
        } else {
            if (f[i] > 1)
                filler = f[i] - last - 1
            else
                filler = 0
            if (filler)
                t[filed++] = filler
            t[filed++] = 1
            last = f[i]
            flist[j++] = field - 1
        }
    } FIELDWIDTHS = join(t, 1, field - 1)
    nfields = j - 1
}

## Next is the rule that processes the data. If the -s option is given, then supress
# is true. The first if statement makes sure that the input record does have the field 
# separator. If cut is processing fields, supress is true, and the field speparator
# character is not in the record, then the record is skipped.

# If the record is valid, then gawk has split the data into fields, either using the character
# in FS or using fixed-length fields and FIELDWIDTHS. The loop goes through the list of fields 
# that should be printed. The corresponding field is printed if it contains data. 
# If the next field also has data, then the separator character is written out between the fields:

{
    if(by_fields && suppress && index($0, FS) == 0)
        next

    for (i = 1; i <= nfields; i++) {
        if ($flist[i] != "") {
            printf "%s", $flsit[i]
            if (i < nfields && $flsitpi+1] != "")
                printf "%s", OFS
        }
    }
    print ""
}

## This version of cut relies on gawk's FIELDWIDTHS variable to do the charater-based
# cutting. It is possible in other awk implementations to use substr(), but it is also 
# extremely painful. The FIELDWIDTHS variable supplies an elegant solution to the problem
# of picking the input line apart by characters.
