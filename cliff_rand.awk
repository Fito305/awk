# cliff_rand.awk --- generate Cliff random numbers

BEGIN { _cliff_seed = 0.1 }

function cliff_rand()
{
    _cliff_seed = (100 * log(_cliff_seed)) % 1
    if (_cliff_seed < 0)
        _cliff_seed = - _cliff_seed
    return _cliff_seed
}

#This algorithm requires an initial "seed" of 0.1.
#Each new value uses the current seed as input for the calculation.
#If the built in rand() function isn't random enough, you might try 
# using this function instead. 
