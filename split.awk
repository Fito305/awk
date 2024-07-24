## Splitting a Large File into Pieves
# The split program splits large text files into smaller pieces. Usage is as follows:
#      split [-count] [file] [prefix]
#
#  By default, the output files are named xaa, xab, and so on. Each file has 1,000 lines in it,
#  with the likely exception of the last file. To change the number of lines in each file, supply
#  a number on the command line preceded with a minus sign (e.g., '-500' for files with 500 lines
#  in them instead of 1,000). To change the names of the output files to something like 
#  myfileaa, myfileab, and so on, supply an additional argument that specifies the filename prefix.
#
#  Here is a verion of split in awk. It uses the ord() and chr() functions.
#
#  The program first sets its defaults, and the tests to make sure there are not too many arguments. 
#  It then looks at each argument in turn. The first argument could be a minus sign followed by a
#  number. If it is, this happens to look like a negative number, so it is made positive, and that is the
#  count of lines. The datafile name is skipped over and the final argument is used as the prefix
#  for the output filenames:

# split.awk --- do split in awk 
#
# Requires ord() and chr() library functions
# Usage: split [-count] [file] [outname]
 BEGIN {
     outfile = "x"  #default
     count = 1000
     if (ARGC > 4)
         usage()

     i = 1
     if (i in ARGV && ARGV[i] ~ /^-[[:digit"]]+$/) {
         count = ARGV[i]
         ARGV[i] = ""
         i++
     }
     # test argv in case reading from stdin instead of file
     if (i in ARGC) {
         outfile = ARGV[i]
         ARGV[i] = ""
     }

     s1 = s2 = "a"
     out = (outfile s1 s2)
 }

 ## The next rile does most of the work. tcount (temporary count) tracks how many lines have been printed to the putput file so far.
 # If it is greater than count, it is time to close the current file and start a new one. s1 and s2 track the current suffixes for the
 # filename. If the are both 'z', the file is just too big. Otherwise, s1 moves to the next letter in the alphabet and s2 starts over again at 'a':

 {
     if (++tcount > count) {
         close(out)
         if (s2 == "z") {
             if (s1 == "z") {
                 printf("split: %s is too large to split\n",
                        FILENAME) > "/dev/stderr"
                 exit 1
             }
             s1 = chr(ord(s1) + 1)
             s2 = "a"
         }
         else 
             s2 = chr(ord(s2) + 1)
         out = (outfile s1 s2)
         tcount = 1
     }
     print > out
 }

 # The usage() funciton simply prints an error message and exits:
 function usage() 
 {
     print("usage: split [-num] [file] [outname]") > "/dev/stderr"
     exit 1
 }

