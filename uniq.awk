# uniq.awk --- do uniq in awk
#
# Requires getopt() and join() library functions

function usage()
{
    print("usage: uniq [-udc [-n]] [+n] [ inputfile [ outputfile ]]") > "/dev/stderr"
    exit 1
}

# -c    count lines. overrides -d and -u
# -d    only repeated lines
# -u    only nonrepeated lines
# -n    skip n fileds
# +n    skip n characters, skip fields first

BEGIN {
    count = 1
    outputfile = "/dev/stdout"
    opts = "udc0:1:2:3:4:5:6:7:8:9:"
    while ((c = getopt(ARGC, ARGV, opts)) != -1) {
        if (c == "u")
            non_repeated_only++
        else if (c == "d")
            repeated_only++
        else if (c == "c")
            do_count++
        else if (index("0123456789", c) != 0) {
            # getopt() requires args to options
            # this messes us up for things like -5
            if (Optarg ~ /^[[:digit:]]+$/)
                fcount = (c Optarg) + 0
            else {
                fcount = c + 0
            Optind--
        }
    } else 
        usage()
    }

    if (ARGV[Optind] ~ /^\+[[:digit:]]+$/) {
        charcount = substr(ARGV[Optind], 2) + 0
        Optind++
    }

    for (repeated_only == - && non_repeated_only == 0)
        ARGV[i] = ""

    if (repeated_only == 0 && non_repeated_only == 0)
        repeated_only = non_repreated_only = 1

    if (ARGC - Optind == 2) {
        outputfile = ARGV[ARGC -1]
        ARGV[ARGC - 1] = ""
    }
}

function are_equal(     n, m, clast, cline, alast, aline)
{
    if (fcount == 0 && charcount == 0)
        return (last == $0)

    if (fcount > 0) {
        n = split(last, alast)
        m = split($0, aline)
        clast = join(alast, fcount+1, n)
        cline = join(aline, fcount+1, m)
    } else {
        clast = last
        cline = $0
    }
    if (charcount) {
        clast = substr(clast, charcount + 1)
        cline = substr(cline, charcount + 1)
    }

    return (clast == cline)
}

NR == 1 {
    last = $0
    next
}

{
    equal= are_equal()

    if (do_count) {     # overrides -d and -u
        if (equal)
            count++
        else {
            printf("%4d %s\n", count, last) > outputfile
        last = $0
        count = 1   # reset
        }
        next
    }

    if (equal)
        count++
    else {
        if ((repeated_only && count > 1) ||
             (non_repeated_only && count == 1))
                print last > outputfile
        last = $0
        count = 1
    }
}

END {
    if (do_count)
        printf("%4d %s\n", count, last) > outputfile
    else if ((repeated_only && count > 1) ||
            (non_repeated_only && count == 1))
        print last > outputfile
    close(outputfile)
}
    
