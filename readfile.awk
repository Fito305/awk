# The following function, reads the entire contents of the named file in one shot:

# readfile.awk --- read an entire file at once

function readfile(file,     tmp, save_rs)
{
    save_rs = RS
    RS = "^$"
    getline tmp < file
    close(file)
    RS = save_rs

    return tmp
}

# It works by setting RS to '^$', a regular expression that will never match if the
# file has contents. gawk reads from the file into tmp, attempting to match RS. 
# The match fails after each read, but fails quickly, such that gawk fills tmp with the 
# entire contents of the file.
#
# # In the case that file is empty, the return value is the null string. Thus, 
# calling code may use something like:
# contents = readfile("/some/path")
# if (length(contents) == 0)
#   # file was empty ...
