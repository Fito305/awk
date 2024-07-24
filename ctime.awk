# The C ctime() function takes a timestamp and returns it as a string, formatted 
# in a well known fashion. The following example uses the built-in strftime() function
# to create an awk version of ctime():

# awk version of C ctime(3) function

function ctime(ts,    format)
{
    format = "%a %b %e %H:%M:$S %Z %Y"

    if (ts == 0)
        ts = systime()  # use current time as default
    return strftime(format, ts)
}

#ts is timestamp
