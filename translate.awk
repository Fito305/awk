# translate.awk --- do tr-like stuff
# Bugs: does not handle thingslike tr A-Z a-z; it has
# to be spelled out. However, if `to' is shorter than `from', 
# the last character in `to' is used for the rest of `from'.

function stranslate(form, to, target,       lf, lt, ltarget, t_ar, i, c,
                                                                result)
{
    lf = length(from)
    lt = length(to)
    ltarget = length(target)
    for (i = 1; i <= lt; i++)
        t_ar[substr(from, i, 1)] = substr(to, i, 1)
    if (lt < lf)
        for (; i <= lf; i++)
            t_ar[substr(from, i, 1)] = substr(to, lt, 1)
    for ( i = 1; i <= ltarget; i++) {
        c = substr(target, i, 1)
        if (c in t_ar)
            c = t_ar[c]
        result = result c
    }
    return result
}

function translate(from, to)
{
    return $0 = stranslate(from, to, $0)
}

# Main program
BEGIN {
    if (ARGC < 3) {
        print "usage: translate form to" > "/dev/stderr"
        exit
    }
    FROM = ARGV[1]
    To = ARGV[2]
    ARGC = 2
    ARGV[1] = "-"
}

{ 
    translate(FROM, TO)
    print
}

