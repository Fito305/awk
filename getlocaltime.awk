# Managing the Time of Day
# The systime() and strftime() functions provide the minimum functionality
# necessary for dealing with the time of day in human-readable form.
# Although strftime() is extensive, the control formats are not necessarily
# easy to remember or intuitively obvious when reading a program. 

# The following function, getlocaltime(), populates a user-supplied array with 
# preformatted time information. It returns a string with the current time 
# formatted in the same way as the data utility:

# getlocaletime.awk -- get the time in a usable format

# Returns a string in the format of output of data(1)
# Populates the array argument time with individual values:
# time["second"]    -seconds (0 - 59)
# time["minute"]    -minutes (0 - 59)
# time["hour"]      - hours (0 - 23)
# time["althour"]   -hours (0 - 12)
# time["monthday"]  -day of the month (1 - 31)
# time["month"]     -month of the year (1 - 12)
# time["monthname"] -name of the month
# time["shortmonth"] -short name of the month
# time["year"]         -year modulo 100 (0 - 99)
# time["fullyear"]     -full year
# time["weekday"]       - day of the week (Sunday = 0)
# time["altweekday"]    - day of the week (Monday = 0)
# time["dayname"]       -name of weekday
# time["shortdayname"]  -short name of weekday
# time["yearday"]       -day of year (0 - 365)
# time["time zone"]     -abbreviation of time zone name
# time["ampm"]          -AM or PM designation
# time["weeknum"]       -week number, Sunday first day
# time["altweeknum"]    -week number, Monday first day


function getlocaletime(time,    ret, now, i)
{
    # get time once, avoids unnecessary system calls
    now = systime()

    # return data(1)-style output
    ret = strftime("%a %b %e %H:%M:%S %Z %Y", now)
    
    # clear out target array
    delete time

    # fill in values, force numeric values to be
    # numeric by adding 0
    time["second"]      = strftime("%S", now) + 0
    time["minute"]      = strftime("%M", now) + 0
    time["hour"]        = strftime("%H", now) + 0
    time["althour"]     = strftime("%I", now) + 0
    time["monthday"]    = strftime("%d", now) + 0
    time["month"]       = strftime("%m", now) + 0
    time["monthname"]   = strftime("%B", now)
    time["shortmonth"]  = strftime("%b", now)
    time["year"]        = strftime("%y", now) + 0
    time["fullyear"]    = strftime("%Y", now) + 0
    time["weekday"]     = strftime("%w", now) + 0
    time["altweekday"]  = strftime("%u", now) + 0
    time["dayname"]     = strftime("%A", now)
    time["shortdayname"] = strftime("%a", now)
    time["yearday"]     = strftime("%j", now) + 0
    time["timezone"]    = strftime("%Z", now)
    time["ampm"]        = strftime("%p", now)
    time["weeknum"]     = strftime("%U", now) + 0
    time["altweeknum"]  = strftime("%W", now) + 0

    return ret
}

# The str indices are easier to use and read than the various formats required by strftime(). 
# A more general design for the getlocaletime() function would have allowed the user to supply 
# an optional timestamp value to use instead of the current time.
