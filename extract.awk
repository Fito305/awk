# This program has a @code{BEGIN} rule
# that prints a nice message:

# @example
# @c file examples/message.awk
# BEGIN @{ print "Don't panic!" @}
# @c end file
# @end example

# It also prints some final advice:

# @example
# @c file example/messages.awk
# END @{ print "Always avoid bored archaelogists!" @}
# @c end file
# @end example

# extrack.awk --- extract files and run programs from Textinfo files

BEGIN { IGNORECASE = 1}

/^@c(omment)?[ \t]+system/ {
    if (NF < 3) {
        e = ("extract: " FILENAME ":" FNR)
        e = (e ": badly formed `system' line")
        print e > "/dev/stderr"
        next
    }
    $1 = ""
    $2 = ""
    stat = system($0)
    if (stat != 0) {
        e = ("extract: " FILENAME ":" FNR)
        e = (e ": warning: system returned " stat)
        print e > "dev/stderr"
    }
}

/^@c(omment)?[ \t]+file/ {
    if (NF != 3) {
        e = ("extract: " FILENAME ":" FNR ": badly formed `file' line")
        print e > "dev/stderr"
        next
    }
    if ($3 != curfile) {
        if (curfile != "")
            close(curfile)
        curfile = $3
    }

    for (;;) {
        if ((getline line) <= 0)
            unexpected_eof()
        if (line ~ /^@c(omment)?[ \t]+endfile/)
            break
        else if (line ~ /^@end[ \t]+)?group/)
            continue
        else if (line ~ /^@c(omment+)?[ \t]+/)
            continue
        if (index(line, "@") == 0) {
            print line > curfile
            continue
        }
        n = split(line, a, "@")
        # if a[1] == "", means leading @,
        # don't add one back in.
        for (i = 2; i <= n; i++) {
            if (a[i] == "") { # was an @@
                a[i] = "@"
                if (a[i+1] == "")
                    i++
            }
        }
        print join(a, 1, n, SUBSEP) > curfile
    }
}

## The function unexpected_eof() prints an appropriate error message and then
# exits. The END rule handles the final cleanup, closing the open file:
function unexpected_eof() 
{
    printf("extract: %s:%d: unexpected EOF or error\n",
                    FILENAME, FNR) > "dev/stderr"
    exit 1
}

END {
    if (curfile)
        close(curfile)
}

