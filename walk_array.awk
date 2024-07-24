# The following function walk_array(), recursively traverses an array, printing
# the element indices and values. You call it with the array and a string representing the name of the array:

function walk_array(arr, name,      i)
{
    for (i in arr) {
        if (isarray(arr[i]))
            walk_array(arr[i], (name "[" i "]"))
        else 
            printf("%s[%s] = %s\n", name, i, arr[i])
    }
}

# It works by looping over each element of the array. If any given element is itself an array, 
# the function calls itself recursively, passing the subarray and a new string representing the current 
# index. Otherwise, the function simply prints the element's name, index, and value.
# Here is a main program to demonstrate:
BEGIN {
    a[1] = 1
    a[2][1] = 21
    a[2][2] = 22
    a[3] = 3
    a[4][1][1] = 411
    a[4][2] = 42

    walk_array(a, "a")
}

## TO RUN:
# gawk -f walk_array.awk


## The function just presented simply prints the name and value of each scalar array
# element. However, it is easy to generalize it, by passing in the name of a function to call when
# walking an array. The modified function looks like this:

function process_array(arr, name, process, do_arrays,   i, new_name)
{
    for (i in arr) {
        new_name = (name "[" i "]")
        if (isarray(arr[i])) {
            if (do_arrays)
                @process(new_name, arr[i])
            process_array(arr[i], new_name, process, do_arrays)
        } else
            @process(new_name, arr[i])
    }
}


# The arguments are as follows:
# arr - the array
# name - the name of the array (a string)
# process - the name of the function to call.
# do_arrays - if this is true, the function can handle elements that are subarrays.
# If subarrays are to be processes, that is done before walking them further.
#
# When run with the following scaffolding, the function produces the same results as does 
# the earlier version of walk_array():

BEGIN {
    a[1] = 1
    a[2][1] = 21
    a[2][2] = 22
    a[3] =3 
    a[4][1][1] = 411
    a[4][2] = 42

    process_array(a, "a", "do_print", 0)
}

function do_print(name, element)
{
    printf "%s = %s\n", name, element
}

