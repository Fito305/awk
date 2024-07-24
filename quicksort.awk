# quicksort.awk --- Quicksort algorithm, with user-supplied
#                   comparison function
# quicksort --- C.A.R. Hoarse's quicksort algorithm. See Wikipedia
#               or almost any algorithm or computer science text.
# The parameters  that use a lot of whitespace are used to specify that it is a local variable. 
function quicksort(data, left, right, less_than,    i, last)
{
    if (left >= right)  # do nothing if array contains fewer
        return          # than two elements

    quicksort_swap(data, left, int((left + right) / 2))
    last = left
    for (i = left + 1; i <= right; i++)
        if (@less_than(data[i], data[left]))
            quicksort_swap(data, ++last, i)
    quicksort_swap(data, left, last)
    quicksort(data, left, last - 1, less_than)
    quicksort(data, last + 1, right, less_than)
}

# quicksort_swap -- helper function for quicksort, should really be inline

function quicksort_swap(data, i, j,    temp)
{
    temp = data[i]
    data[i] = data[j]
    data[j] = temp
}

# num_lt --- do a numeric less than comparison

function num_lt(left, right)
{
    return ((left + 0) < (right + 0))
}

# num_ge --- do a numeric greater than or equal to comparison
# num_ge() is needed to perform a descending sort; when used to perform a 
# "less than" test, it actually does the opposite (greater than or equal to), which yields 
# data sorted in descending order.
function num_ge(left, right)
{
    return ((left + 0) >= (right + 0))
}

# Next comes a sorting function. It is parameterized with the starting and ending field 
# numbers and the comparison function. It builds an array with the data and calls
# quicksort() appropriately, and then formats the results as a single string:
# do_sort --- the data according to `compare`
#             and return it as a string

function do_sort(first, last, compare,      data, i, retval)
{
    delete data
    for (i = 1; first <= last; first++) {
        data[i] = $first
        i++
    }

    quicksort(data, 1, i-1, compare)
    retval = data[1]
    for (i = 2; i in data; i++)
        retval = retval " " data[i]

    return retval
}

# Finally, the two sorting functions call do_sort(), passing in the names of the two 
# comparison functions:
# sort --- sort the data in ascending order and return it as a string

function sort(first, last)
{
    return do_sort(first, last, "num_lt")
}

# rsort -- sort the data in descending order and return it as a string
function rsort(first, last)
{
    return do_sort(first, last, "num_ge")
}
