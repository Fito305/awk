# getopt.awk --- Do C library getopt(3) function in awk

# External variables:
#   Optind-index in ARGV of first nonoption argument
#   Optarg-string value of argument to current option
#   Opterr-if nonzero, print our own diagnostic
#   Optopt-current option letter

# Returns:
# -1    at end of options
# "?"   for unrecongnized option
# <c>   a character representing the current option

# Private Data:
#   _opti -index in multiflag option, e.g., -abc


### The function starts out with comments presenting a list of the gloabl variables it uses, 
# what the return values are, what they mean, and any global variables that are "private" to 
# this library function. Such documentation is essential for any program, and particularly for 
# library functions.
