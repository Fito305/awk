# This style of programming works, but can be awkward. With indirect function calls, 
# you tell gawk to use the value of a variable as the name of the function call.
# The syntax is similar to that of a regular function call: an identifier immediately followed
# by an opening parenthesis, any arguments, and then a closing parenthesis, with the addition of a leading '@' character:

# the_func = "sum"
# result = @the_func()  # calls the sum() function

# Demonstrate indirect function calls
# average --- return the average of the values in fields $first - $last

function average(first, last,    sum, i)
{
    sum = 0;
    for (i = first; i <= last; i++)
        sum += $i

    return sum / (last - first + 1)
}

# sum -- return the sum of the values in fields $first - $last
function sum(first, last,       ret, i)
{
    ret = 0;
    for (i = first; i <= last; i++)
        ret += $i

    return ret
}

# These two functions expect to work on fileds; thus, the parameters first and last 
# indicate where in the fileds to start and end. Otherwise, they perform the expected
# computations and are not unusual:

# For each record, print the class name and the requested statistics
{ 
    class_name = $1
    gsub(/_/, " ", class_name) # Replace _ with spaces

    # find start
    for (i = 1; i <= NF; i++) {
        if ($i == "data:") {
            start = i + 1
            break
        }
    }

    printf("%s:\n", class_name)
    for (i = 2; $i != "data:"; i++) {
        the_function = $i
        printf("\t%s: <%s>\n", $i, @the_function(start, NF) "")
    }
    print ""
}

