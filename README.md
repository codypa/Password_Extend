This is a deployment script that was made to indirectly extend the expiration of all local account passwords of a Linux machine by re-attributing the password creation date to the machine's current date.

Contents:
1. Directory creation (usr/local/cScripts). All other scripts will be deployed within this directory.
2. Configuration file creation: users.conf (referencing all bash accounts in /etc/passwd).
3. NewUser.sh script creation: This script takes a username as an arguement and creates the user, assigns it to the wheel group, adds it to the users.conf file to take part in password extension, and prompts for a user password.
4. RemoveUser.sh script creation: Deletes a user, and removes the user from the users.conf file.
5. Passwd_extend.sh script creation: Referencing the users.conf file, this will reset the password for each user contained within.
6. Cronjob creation: This will run the passwd_extend.sh script every night at midnight.

UPDATE:
- Script has been updated with passwd_ext2.sh
