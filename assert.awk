# assert --- assert that a condition is true. Otherwise, exit.

function assert(condition, string)
{
    if (! condition) {
        printf("%s:%d: assertion failed: %s\n",
               FILENAME, FNR, string) > "/dev/stderr"
        _assert_exit = 1
        exit 1
    }
}

END {
    if (_assert_exit)
        exit 1
}

# The C language makes it possible to turn the condition into a string for use in 
# printing the diagnostic message. This is not possible in awk, so "this" assert() function also
# requires a string version of the condition that is being tested. Following the function above:

# The assert() function tests the condition parameter. If it is false, it prints a message to standard error, 
# using the string parameter to describe the failed condition. It then sets the variable _assert_exit to one 
# and executes the exit statement. The exit statement jumps to the END rule. If the END rule finds _assert_exit to be true,
# it exists immediately.

# The purpose of the test in the END rule is to keep any other END rule from running. When an assertion fails, the program should exit immediately. 
# If no assertions fail, then _assert_exit is still false when the END rule is run normally, and the rest of the program's 
# END rule execute. 
# ```
# For all of this to work correctly, assert.awk must be the first source file ready by awk. 
# ```

# The function can be used in a program in the following way:
# function myfunc(a, b)
# {
#       assert(a <= 5 && b >= 17.1, "a <= 5 && b >= 17.1")
# }

# If the assertion fails, you see a message similar to the following:
# `mydata:1357: assertion failed: a <= 5 && b >- 17.1

