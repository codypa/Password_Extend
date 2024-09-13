#!/bin/bash

########__PROD DIR__############
if [ -d "/usr/local/cScripts" ]; then
	echo -e "\033[0;33mcScripts directory already exists"
else
	mkdir /usr/local/cScripts
	chmod 740 /usr/local/cScripts
	echo "Created /usr/local/cScripts directory"
fi

#########__MAKE USER CONF__###########

if [ -f "/usr/local/cScripts/users.conf" ]; then
	echo -e "\033[0;33musers.conf already exists"
else
	touch /usr/local/cScripts/users.conf
	chmod 740 /usr/local/cScripts/users.conf
	echo "created users.conf"
  #########__TRANSFER USERS__########
	touch /usr/local/cScripts/temp1
	grep "bash$" /etc/passwd > /usr/local/cScripts/temp1
	cut -d ":" -f 1 /usr/local/cScripts/temp1 >> /usr/local/cScripts/users.conf
	rm /usr/local/cScripts/temp1
fi

##########__USER ADD SCRIPT__#########

if [ -f /usr/local/cScripts/NewUser.sh ]; then
	echo -e "\033[0;33mNewUser.sh already exists"
else
	touch /usr/local/cScripts/NewUser.sh
	chmod 740 /usr/local/cScripts/NewUser.sh
	echo "#!/bin/bash
	useradd \$1
	usermod -aG wheel \$1
	echo \$1 >> /usr/local/cScripts/users.conf
	passwd \$1" >> /usr/local/cScripts/NewUser.sh
	echo "NewUser.sh script created"
fi

###########__USER REMOVE SCRIPT__#######

if [ -f /usr/local/cScripts/RemoveUser.sh ]; then
	echo -e "\033[0;33mRemoveUser.sh script already exists"
else
	touch /usr/local/cScripts/RemoveUser.sh
	chmod 740 /usr/local/cScripts/RemoveUser.sh

	echo "#!/bin/bash
	userdel -r \$1
	sed -i \"/^$/d; s/\${1}//g\" \"/usr/local/cScripts/users.conf\"" >> /usr/local/cScripts/RemoveUser.sh
	echo "Created RemoveUser script"
fi

############__PASSWORD EXTENDER__########

if [ -f /usr/local/cScripts/passwd_extend.sh ]; then
	echo -e "\033[0;33mpasswd_extend script already exists"
else
	touch /usr/local/cScripts/passwd_extend.sh
	chmod 740 /usr/local/cScripts/passwd_extend.sh
	echo "#!/bin/bash
	for i in \`cat /usr/local/cScripts/users.conf\`;
	do
	sudo chage -d \$(date +%Y-%m-%d) \$i;
	done" >> /usr/local/cScripts/passwd_extend.sh
	echo "passwd_extend script created"
fi

##########__CRON JOB__##############

if crontab -l | grep -q "/usr/local/cScripts/passwd_extend.sh"; then
	echo -e "\033[0;33mPassword extend cronjob already exists"
else
	(crontab -l ; echo "0 0 * * * /usr/local/cScripts/passwd_extend.sh") | crontab -
fi

##########__CLEANUP FUNCTION__##############

cleanup() {
	rm -rf /usr/local/cScripts
	crontab -l | grep -v "/usr/local/cScripts/passwd_extend.sh" | crontab -
	echo -e "\033[0;31mDeployment has been cleaned."
}
$1

###########__FINISH__###############

echo -e "\033[0;34mScript has finished"
echo -e "\033[0m"

######################################
###__CREATED BY CODY PASCUAL__########
######################################
