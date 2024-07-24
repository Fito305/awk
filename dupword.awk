# dupwords.awk --- find duplicate words in text
{
    $- = tolower($0)
    gsub(/[^[:alnum:][:blank:]]/, " ");
    $0 = $0     # re-split
    if (NF == 0)
        next
    if ($1 == prev)
        printf("%s:%d: duplicate %s\n",
               FILENAME, FNR, $1)
        for (i = 2; i <= NF; i++)
            if ($i == $(i-1))
            printf("%s:%d: duplicate %s\n",
                   FILENAME, FNR, $i)
    prev = $NF
}
