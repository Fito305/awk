// getpwent() is defined as returning a pointer to a struct passwd. 
// Each time it is called, it returns the next entry in the database.
// When there are no more entries, it returns NULL, the null pointer. When 
// this happens, the C program should call endpwent() to close the 
// database. Following is pwcat, a C program that "cats" the password
// database:

/*
 * pwcat.c
 *
 * Generate a printable version o fthe password database.
 */
#include <stdio.h>
#include <pwd.h>

int 
main(int argc, char **argv)
{
    struct passwd *p;

    while ((p = getpwent()) != NULL)
        printf("%s:%s:%1d:%1d:%s:%s:%s\n",
                p->pw_name, p->pw_passwdm, (long) p->pw_uid,
                (long) p->pw_gid, p->pw_gecos, p->pw_dir, p->pw_shell);

    endpwnet();
    return 0;
}


/* The output from pwcat is the user database, in the traditional /etc/passwd format
 * of colon-separated fields. The fields are:
 * Login name
 *  The user's login name.
 * Encrypted password
 *  The user's encrypted password. This may not be available on some systems.
 * User-ID
 *  The user's numeric user ID number. (On some systems, it's a C long, and not an int.
 *  Thus, we cast it to long for all cases.)
 * Group-ID
 *  The user's numeric group ID number. (Similar comments about long versus int apply here.)
 * Full name
 *  The user's full name, and perhaps other information associated with the user.
 * Home directory 
 *  The user's login (or "home") directory ( familiar to shell programmers as $HOME).
 * Login shell
 *  The program that is run when the user logs in. This is usually a shell, such as Bash.
 *
 *  $ pwcat             # TO run the command
