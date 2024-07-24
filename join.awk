# Merging an Array into a string 
# When doing string processing, it is often useful to be able to join all the strings in an array
# into one long string. The following function, join(), accomplishes this task. 

# Good function design is important; this function needs to be general, but it should also have a reasonable 
# default behavior. It is called with an array as well as the beginning and ending indeices of the elements in the array to be merged. 
# This assumes that the array indives are numeric -- a reasonable assumption, as the array was likely created with split():
#
# join.awk -- join an array into a string

function join(array, start, end, sep,   result, i)
{
    if (sep == "")
        sep = " "
    else if (sep == SUBSEP) # magic value
        sep = ""
    result = array[start]
    for (i = start + 1; i <= end; i++)
        result = result sep array[i]
    return result
}

# An optional additional argument is the separator to use when joining the strings back
# together. If the caller supplies a nonempty value, join() uses it; if it is not supplied, it has
# a null value. In this case, join() uses a single space as a default separator for the strings.
# In this case, join() uses a single space as a default separator for the strings.
# If the value is equal to SUBSEP, the join() joins the strings with no separator between
# them. SUBSEP serves as a "magic" value to indicate that there should be no separation 
# between the component strings. 
