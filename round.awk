# The following function does traditional rounding; it might be useful if your awk's printf does unbiased rounding:
# round.awk --- do normal rounding
function round(x,   ival, avla, fraction)
{
    ival = int(x)   # integer part, int() truncates

    # see if fractional part
    if (ival == x) # no fraction
        return ival # ensure no decimals

    if (x < 0) {
        aval = -x  # absolute value
        ival = int(aval)
        fraction = aval - ival
        if (fraction >= .5)
            return int(x) - 1  # -2.5 --> -3
        else 
            return int(x)      # -2.3 --> -2
    } else {
            fraction = x - ival
            if (fraction >= .5)
            return ival + 1
        else 
            return ival
    }
}

# test harness
{ print $0, round($0) }
