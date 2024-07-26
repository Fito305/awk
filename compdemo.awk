# function comp_func(i1, v1, i2, v2)
# {
#     compare elements 1 and 2 in some fashion
#     return < 0; 0; or > 0
# }

function cmp_num_idx(i1, v1, i2, v2)
{
    # numberical index comparison, ascending order
    return (i1 - i2)
}

function cmp_str_val(i1, v1, i2, v2)
{
    # string value comparison, ascending order
    v1 = v1 ""
    v2 = v2 ""
    if (v1 < v2)
        return -1
    return (v1 != v2)
}

function cmp_num_str_val(i1, v1, i2, v2,    n1, n2)
{
    # numbers before string value comparison, ascending order
    n1 = v1 + 0 # converts a string into a number by adding 0 to it.
    n2 = v2 + 0
    if (n1 == v1)
        return (n2 == v2) ? (n1 - n2) : -1
    else if (n2 == v2)
        return 1
    return (v1 < v2) ? -1 : (v1 != v2)
}

# Here is a main program to demonstrate how gawk behaves using each of the previous functions:
BEGIN {
    data["one"] = 10
    data["two"] = 20
    data[10] = "one"
    data[100] = 100
    data[20] = "two"

    f[1] = "cmp_num_idx"
    f[2] = "cmp_str_val"
    f[3] = "cmp_num_str_val"
    for (i = 1; i <= 3; i++) {
        printf("Sort function: %s\n", f[i])
        PROCINFO["sorted_in"] = f[i] ## Using Predefined Array Scanning Orders with gawk describes how you can assign special, 
                                     # predefined values to PROCINFO["sorted_in"] in order to control the order in which gawk
                                     # traverses an array during a for loop.
        for (j in data)
            printf("\tdata[%s] = %s\n", j, data[j])
        print ""
    }
}

# Run the program:
# $ gawk -f comdemo.awk
