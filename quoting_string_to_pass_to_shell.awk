#! /bin/sh

### Michael Brennan offers the following programming pattern, which he uses frequently: 
### included below and above.

awkp='
    ...
    '

# Use in termianl    
# input_program | awk "$awkp" | /bin/sh
# For example, a program of his named flac-edit has this form:
# $ flac-edit -song="Whoope! That's Great" file.flac

# It generates the following output, which is to be piped to the shell (/bin/sh).

# Note the need for shell quoting. The function sheell_quote() deos it. SINGLE is 
# one-character string"" and QSINGLE is the three character string "\"'\"":
    # shell_quote -- quote an argument for passing to the shell

function shell_quote(s,         
    SINGLE, QSINGLE, i, X, n, ret)  # locals
{
    if (s == "")
    return "\"\""

    SINGLE = "\x27" #single quote
    QSINGLE = "\"\x27\""
    n = split(s, X, SINGLE)

    ret = SINGLE X[1] SINGLE
    for (i = 2; i <= n; i++)
        ret = ret QSINGLE SINGLE X[i] SINGLE

    return ret
}

