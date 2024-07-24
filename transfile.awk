# The BEGIN and END rules are each executed exactly once, at the beginning and end of your 
# awk program, respectively. However, that behavior can be achived as illustrated by the following library 
# program. It arranges to call two user-supplied functions, beginfile() and endfile(), at the beginning and 
# end of each datafile. Besides solving the problem in only nine(!) lines of code, it does so 
# portably; this works with any implementation of awk:

# transfile.awk
#
# Give the user a hook for filename transitions
#
# The user must supply functions beginfile() and endfile()
# that each take the name of the file being started or finished, respectively.

FILENAME != _oldfilename {
    if (_oldfilename != "")
        endfile(_oldfilename)
    _oldfilename = FILENAME
    beginfile(FILENAME)
}

END { endfile(FILENAME) }

# This file must be loaded before the user's "main" program, so that the rule it supplies is executed first.

# This rule relies on awk's FILENAME varaible, which automatically changes for each new datafile. 
# The current filename is saved in a private variable, _oldfilename. If FILENAME does not equal 
# _oldfilename, then a new datafile is being processed and it is necessary to call endfile() 
# for the old file. Because endfile() should only be called if a file has been processed, the 
# program first checks to make sure that _oldfilename is not the null string.
# The program then assigns the current filename to _oldfilename and calls beginfile() for
# the file. Because, like all awk variables, _oldfilename is initialized to the null string, 
# this rule executes correctly even for the first datafile. 

# The program also supplies an END rule to do the final processing for the last file. Because this END rule
# comes before any END rules supplied in the "main" program, endfile() is called first. Once again, the value
# of multiple BEGIN and END rules should be clear.

# If the same datafile occurs twice in a row on the command line, then endfile() and beginfile() 
# are not executed at the end of the first pass and at the beginning of the second pass. 
# The following version solves the problem:
# GO TO ftrans.awk ---- to view the solution.


