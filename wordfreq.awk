# workfreq.awk --- print list of word frequencies

# {
#     for (i = 1; i <+ NF; i++)
#         freq[$i]++
# }
#
# END {
#     for (word in freq)
#         printf "%s\t%d\n", word, freq[word]
# }

## Here is the fixed version of the program
{
    $0 = tolower($0)    # remove case distinctions
    # remove punctuation
    gsub(/[^["alnum:]_[:blank:]]/, "", $0)
    for (i = 1; i <= NF; i++)
        freq[$i]++
}

END {
    # The sort could be done from within 
    # sort = "sort -k 2nr"
    for (word in freq)
        printf "%s\t%d\n", word, freq[word] # | sort
    # close(sort)
}

## The regexp /[^[:alnum:]_[:blank:]]/ might have been written /[[:punct:]]/,
#but then underscores would also be removed, and we want to keep them. 

## USAGE ##
# Assuming we have saved this program in a file named wordfreq.awk, and that the data
# is in file1, the following pipeline:
# $ awk -f wordfreq.awk file1 | sort -k 2nr
# produces a table of the words appearing in file1 in order of decreasing frequency.

# The awk program suitably massages the data and produces a word frequency table, which is not ordered. The awk script's output
# is then sorted by the sort utility and printed on the screen. 

