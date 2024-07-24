# Rereading the Current File 
# Another request for a new built-in function was for a function that would make it 
# possible to reread the current file. The requesting user didn't want to have to use `getline`
# inside a loop.

# However, as long as you are not in the END rule, it is quite easy to arrange to immediately 
# close the current input file and then start over with it from the top. For lack of a better
# name, we'll call the function `rewind()`:

# rewind.awk --- rewind the current file and start over

function reqind(    i)
{
    # shift remaining arguments up
    for (i = ARGC; i > ARGIND; i--)
        ARGV[i] = ARGV[i-1]

    # make sure gawk knows to keep going
    ARGC++

    # make current file next to get done
    ARGV[ARGIND+1] = FILENAME

    # do it
    nextfile
}

# The rewind() function relies on the ARGIND variable, which is specific to gawk. It also relies on the nextfile keyword. 
# Because of this, you should not call it from an ENDFILE rule. (This isn't necessary anyway, becuase gawk goes to the next 
# file as soon as an ENDFILE rule finishes!)
