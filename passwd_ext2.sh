#!/bin/bash

########__PROD DIR__############
if [ -d "/usr/local/cScripts" ]; then
	echo -e "\033[0;33mcScripts directory already exists"
else
	mkdir /usr/local/cScripts
	chmod 740 /usr/local/cScripts
	echo "Created /usr/local/cScripts directory"
fi

#######__CREATE SCRIPT__#######
if [ -f /usr/local/cScripts/passwd_ext2.sh ]; then
	echo -e "\033[0;33mpasswd_ext2.sh already exists"
else
	touch /usr/local/cScripts/passwd_ext2.sh
	chmod 740 /usr/local/cScripts/passwd_ext2.sh
	echo "#!/bin/bash
	for i in $(grep "bash$" /etc/passwd | awk -F ':' '{ print $1 }')
  do
      chage -d $(date +%Y-%m-%d) $i
  done" >> /usr/local/cScripts/passwd_ext2.sh
	echo "passwd_ext2.sh script created"
fi

##########__CRON JOB__##############

if crontab -l | grep -q "/usr/local/cScripts/passwd_ext2.sh"; then
	echo -e "\033[0;33mPassword extend cronjob already exists"
else
	(crontab -l ; echo "0 0 * * * /usr/local/cScripts/passwd_ext2.sh") | crontab -
fi
