# One commercial implementation of awk supplies a built-in function, ord(), which
# takes a character and returns the numeric value for that character in the machine's character set. 
# If the string passed to ord() has more than one character, only the first one is used. 

# The inverse of this function is chr() (from the function of the same name in Pascal),
# which takes a number and returns the corresponding character. Both funcitons are written very nicely in awk; 
# there is no real reason to build them into the awk interpreter:

# ord.awk -- do ord and chr

# Global indentifiers:
# _ord_:    numerical value indexed by characters
# _ord_init:    function to initialize _ord_

BEGIN { _ord_init() }

function _ord_init(     low, high, i, t)
{
    low = sprintf("%c", 7) # BEL is ascii 7 
    if (low == "\a") {      # regular ascii
        low = 0
        high = 127 
    } else if (sprintf("%c", 128 + 7) == "\a") {
        # ascii, mark parity
        low = 128
        high = 255
    } else {        # ebcdic(!)
        low = 0
        high = 255
    }

    for (i = low; i <= high; i++) {
        t = sprintf("%c", i)
        _ord_[t] = i
    }
}

# Some explanation of the numbers used by _ord_init() is worthwhile. The most
# prominent character set in use today is ASCII. Although an 8-bit byte can hold 256 
# distinct values (from 0 to 255), ASCII only defines characters that use the values from 0 
# to 127. In the now distant past, at least one minicomputer manufacturer used ASCII, but
# with mark parity, meaning tha that the lestmost bit in byte is always 1. This means
# that on those systems, characters have numeric values from 128 to 255. Finally, large mainframe
# systems use the EBCDIC character set, which uses all 256 values. There are ohter character sets 
# in use on some older systems, but they are not really worth worrying about:

function ord(str,   c)
{
    # only first character is of interest
    c = substr(str, 1, 1)
    return _ord_[c]
}

function chr(c)
{
    # force c to be numeric by adding 0
    return sprintf("%c", c + 0)
}

### test code ###
BEGIN {
    for (;;) {
        printf("enter a character: ")
        if (getline var <= 0)
            break
        printf("ord(%s) = %d\n", var, ord(var))
    }
}

# An obvious improvement to these function is to move the code for the _ord_init function into
# the body of the BEGIN rule. It was written this way initially for ease of development. There
# is a "test program" in a BEGIN rule, to test the function. It is 
# commented out for production use.
