# mystrtonum --- convert string to a number

function mystrtonum(str,    ret, n, i, k, c)
{
    if (str ~ /^0[0-7]*$/) {
        #octal
        n = length(str)
        ret = 0
        for (i = 1; i <= n; i++) {
            c = substr(str, i, 1) 
            # index() returns 0 if c not in string,
            # includes c == "0"
            k = index("1234567", c)

            ret = ret * 8 + k
        }
    } else if (str ~ /^0[xX][[:xdigit:]]+$/) {
        # hexadecimal
        str = substr(str, 3) # lop off leading 0x
        n = length(str)
        ret = 0
        for (i = 1; i <= n; i++) {
            c = substr(str, i, 1)
            c = tolower(c)
            # index() returns 0 if c not in string,
            # includes c == "0"
            k = index("123456789abcdef", c)

            ret = ret * 16 + k
        }
    } else if (str ~ \
           /^[-+]?([0-9]+([.][0-9]*([Ee][0-9]+)?)?|([.][0-9]+([Ee][-+]?[0-9]+)?))$/) {
               # decimal number, possibly floating point 
               ret = str + 0
    } else
                ret = "NOT-A-NUMBER"
    
    return ret
}

# The BEGIN below was commented out.
BEGIN {   # gawk test harness
     a[1] = "25"
     a[2] = ".31"
     a[3] = "0123"
     a[4] = "0xdeadBEEF"
     a[5] = "123.45"
     a[6] = "1.e3"
     a[7] = "1.32"
     a[8] = "1.32E2"

     for (i = 1; i in a; i++)
          print a[i], strtonum(a[i]), mystrtonum(a[i])
}


# The function first looks for C-style octal numbers (base 8). If the input string matches a regular expression describing octal numbers, then mystrtonum()
# loops through each character in the string. It sets k to the index in "1234567" of the current octal digit. Thereturn value will either be the same number as the digit,
# or zero if the character is not there, which will be true for a '0'. This is safe, because the regexp test in the if ensures that only octal values are converted.

# Similar logic applies to the code that checks for an converts a hexadecimal value, which starts with '0x' or '0X'.
# The use of tolower() simplifies the computation for finding the correct numeric value for each hexadecimal digit.

# Finally, if the string matches the (rather complicated) regexp for a regular decimal integer or floating-point number,
# the computation 'ret = str + 0' lets awk convert the value to a number. (string + 0) in awk converts a string to a number.

# A commented out test program is included, so that the function can be tested with gawk and the results compared to the build-in strtonum() function.
            
