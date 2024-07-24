# Treating Assignments as Filenames
# Occasionally, you might not want awk to process command-line variables assignments. 
# In particular, if you have a filename that contains an '=' character, awk treats the 
# filename as an assignment and does not process it.

# Some users have suggested an additional command-line option for gawk to disable
# command-line assignments. However, some simple programming with a library file does
# the trick:

# noassign.awk --- library file to avoid the need for a 
# special option that disables command-line assignments

function disable_assigns(argc, argv,    i)
{
    for (i = 1; i < argc; i++)
        if (argv[i] ~ /^[a-zA-Z_][a-zA-Z0-9_]*=.*/)
            argv[i] = ("./" argv[i])
}

BEGIN {
    if (No_command_assign)
        disable_assigns(ARGC, ARGV)
}

# YOu then run your program this way:
# $ awk -v No_command_assign=1 -f noassign.awk -f yourprog.awk *

# The function works by looping through the arguments. It prepends './' to any argument
# that matches the form of a variable assignment, turning that argument into a filename.

# The use of No_command_assign allows you to disable command-line assignments at invocation time,
# by giving the variable a true value. When not set, it is initially zero (i.e., false),
# so the command-line arguments are left alone. 
