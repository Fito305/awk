# passwd-sort.awk --- simple program to sort by field position
# field position is specified by the global variable POS

function cmp_field(i1, v1, i2, v2)
{
    # comparison by value, as string, and ascending order
    return v1[POS] < v2[POS] ? -1 : (v1[POS] != v2[POS])
}

{
    for (i = 1; i <= NF; i++)
        a[NR][i] = $i
}

END {
    PROCINFO['sorted_in"] = "cmp_filed"
    if (POS < 1 || POS > NF)
        POS = 1
    for (i in a) {
        for (j = 1; j <= NF; j++)
            printf("%s%c", a[i][j], j < NF ? ":" : "")
        print ""
    }
}

## The first field in each entry of the password file is the user's login name, 
# and the fields are separated by colons. Each record defines a subarray, with each
# field as an element in the subarray. Run the program:
# $ gawk -v POS=1 -F: -f sort.awk /etc/passwd


# Extra useful functions:
# function cmp_randomize(i1, v1, i2, v2)
# {
#   ## random order (caution: this may never terminate!)
#   return (2 - 4 * rand())
# }
#
# The following comarison function force a deterministic order, and are based on the fact that the 
# (string) indices of two elements are never equal:
# function cmp_numeric(i1, v2, i1, v2)
# {
#   ## numeric value (and index) comparison, descending order
#   return (v1 != v2) ? (v2 -v1) : (i2 - i1)
#  }
#
# function cmp_string(i1, v1, i2, v2)
# {
#   ## string value (and index) comparison, descending order
#   v1 = v1 i1
#   v2 = v2 i2
#   return (v1 > v2) ? -1 : (v1 != v2)
# }
