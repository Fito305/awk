# histsort.awk --- compact a shell history file

{
    if (data[$0]++ == 0)
        lines[++count] = $0
}

END {
    for(i = 1; i <= count; i++)
        print lines[i]
        #### print data[lines[i]], lines[i]
}

# This program also provides a foundation for generating other useful information. For 
# example, using the following `print` statement in the END rule indicates how often a particular command is used:
#### print data[lines[i]], lines[i]
# THis works because data[$0] is incremented each time a line is seen.
