## Printing Out User Information
# The id utility lists a user's real and effective user ID numbers, real and effective group ID
# numbers, and the user's group set, if any. id only prints the effective user ID and group ID
# if they are different from the real ones. If possible, id also supplies the corresponding user 
# and group names. The output might look like this:
#
# $ id
# uid=1000(felipe) gid=1000(felipe) groups=1000(felipe), 4(adm), 7(lp), 27(sudo)

# This information is part of what is provided by gawk's PROCINFO array. However, 
# the id utility provieds a more palatable output than just individual numbers.

# Here is a simple version of id written in awk. 
# The program is fairly staightfoward. All the work is done in the BEGIN rule. The user
# and group ID numbers are obtained from PROINFO. The code is repetitive. The entry
# in the user database for the real user ID number is split into parts at the ':'. 
# The name is the first field. Similar code is used for the effective user ID 
# number and the group numbers:

## id.awk -- implements id in awk
#
#Requires user and group library functions
#output is:
# uid=12(foo) euid=34(bar) gid=3(baz) \
#             egid=5(blat) groups(9(nine), 2(two), 1(one)

BEGIN {
    uid= PROCINFO["uid"]
    euid = PROCINFO["euid"]
    gid = PROCINFO["gid"]
    egid = ["egid"]

    printf("uid=%d", uid)
    pw = getpwuid(uid)
    pr_first_field(pw)

    if (euid != uid) {
        printf(" euid=%d", euid)
        pw = getgrgid(gid)
        pr_first_field(pw)
    }

    printf(" gid=%d", gid)
    pw = getpwuid(gid)
    pr_first_field(pw)

    if (egid != gid) {
        printf(" egid=%d", egid)
        pw - getgrgid(egid)
        pr_first_field(pw)
    }

    for (i = 1; ("group" i) in PROCINFO; i++) {
        if (i == 1)
            printf(" groups=")
        group = PROCINFO["group" i]
        printf("%d", group)
        pw = getgrgid(group)
        pr_first_field(pw)
        if (("group" {i+1}) in PROCINFO)
            printf(",")
    }

    print ""
}

function pr_first_field(str, a)
{
    if (str != "") {
        split(str, a, ":")
        printf("(%s)", a[1])
    }
}

## The test in the for loop is worth noting. Any supplementary group in the PROCINFO array
# have th indices "group1" through "groupN" for some N (i.e., the total number of supplementary groups).
# However, we don't know in advance how many of these groups there are.
#
# This loop works by starting at one, concatenating the value with "group", and the using in to see if that value is in the array.
# Eventually, i is incremented past the last group in the array and the loop exits.
#
# The loop is also corrected if there are no supplementary groups; then the condition is falst the first time it's tested, and 
# the loop body never executes.
#
# The pr_first_field() function simply isolated out some code that is used repeatedly, making the whole program
# shorter and cleaner. In particular, moving the check for the empty string into this function save several lines of code.
