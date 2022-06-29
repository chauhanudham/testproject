#!/bin/bash

printf "\n -------------------------------------------------"
printf "\n SSH Configuration"
printf "\n -------------------------------------------------\n"


echo "Protocol 2" >> /etc/ssh/sshd_config   #Allow Only SSH Protocol 2, There are two versions of the SSH protocol. Using SSH protocol 2 only is much more secure; SSH protocol 1 is subject to security issues including man-in-the-middle and insertion attacks.

echo "X11Forwarding no" >> /etc/ssh/sshd_config #These items allow the traffic to be forwarded over to your computer from the host and also allow forwarding to be used.

echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config #SSH can emulate the behavior of the obsolete rsh command in allowing users to enable insecure access to their accounts via .rhosts files.

echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config #SSH’s cryptographic host-based authentication is more secure than .rhosts authentication. However, it is not recommended that hosts unilaterally trust one another, even within an organization.

echo "PermitRootLogin no" >> /etc/ssh/sshd_config #Disable root logins via SSH

echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config #The SSH daemon must not permit user environment settings.

echo -e  "successfully changed  ssh  configuration file\n"


printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
read -p "Please enter List of users to be denied via ssh separated by space: " user_ssh
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

for user_sh in $user_ssh
do
echo $user_sh
print "\n"
echo "DenyUsers $user_sh" >> /etc/ssh/sshd_config
done

systemctl restart sshd   > /dev/null

echo -e "ssh service restarted"

status=$?
echo "exit status $status"
if [ $status != 0 ]
then 
	exit $status
fi

printf "\n -------------------------------------------------"
printf "\n World-Writable Files"
printf "\n -------------------------------------------------\n"
read -p "Please enter mount points where you want to check World-Writable Files, seprated by spaces " world_writable

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

for writable in $world_writable
do
echo $writable
find $writable -perm -ugo+rwx
done




printf "\n -------------------------------------------------"
printf "\n No-owner Files"
printf "\n -------------------------------------------------\n"



read -p "Please enter mount points where you want to check  No-owner Files, seprated by spaces " no_owner

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

for owner in $no_owner
do
echo $owner
find $owner -xdev \( -nouser -o -nogroup \) -print
done


###SELinux Enable
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

printf " Enabling SELinux, Please disable if requred. " 

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

sudo sed -i 's/SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config 



printf "\n -------------------------------------------------"
printf "\n File Permission Change"
printf "\n -------------------------------------------------\n"

chmod 600 /etc/fstab         ; ls -ll /etc/fstab
chmod 644 /etc/hosts.allow   ; ls -ll /etc/hosts.allow 
chmod 644 /etc/hosts.deny    ; ls -ll  /etc/hosts.deny
chmod 055 /sbin/route        ; ls -ll  /sbin/route
chmod 640 /var/log/*         ; ls -ld /var/log/*
chmod 600 /var/log/wtmp      ; ls -ll /var/log/wtmp
chmod 550 /usr/sbin/chroot   ; ls -ll  /usr/sbin/chroot
chmod 600 /etc/aliases.db    ; ls -ll /etc/aliases.db
chmod 600 /etc/aliases       ; ls -ll /etc/aliases
chmod 600 /etc/cron.deny     ; ls -ll /etc/cron.deny
chmod 600 /etc/exports       ; ls -ll /etc/exports
chmod 750 /etc/default/      ; ls -ld /etc/default/
chmod 600 /etc/login.defs    ; ls -ll /etc/login.defs
chmod 600 /boot/grub2/grub.cfg ; ls -ll /boot/grub2/grub.cfg


printf "\n -------------------------------------------------"
printf "\n File Permission Change"
printf "\n -------------------------------------------------\n"

chmod 640 /etc/passwd
chmod 600 /etc/shadow
chmod 644 /etc/at.allow
chmod 600 /etc/at.deny
chmod 644 /etc/bashrc
chmod 600 /etc/cron.allow
chmod 644 /etc/crontab
chmod 644 /etc/hosts
chmod 600 /etc/resolv.conf
chmod 644 ~/.bash_history
chmod 644 ~/.bash_logout
chmod 644 ~/.bash_profile
chmod 644 ~/.bashrc

printf "\n -------------------------------------------------"
printf "\n Default Services Enabled"
printf "\n -------------------------------------------------\n"

systemctl list-unit-files --type=service | grep  enabled

printf "\n -------------------------------------------------"
printf "\n  Extended File limit size"
printf "\n -------------------------------------------------\n"

echo "#<domain>  <type>     <item>      <value>"     >>    /etc/security/limits.conf
echo "*           soft        nproc     8192"        >>    /etc/security/limits.conf    # soft for enforcing the soft limits
echo "*           hard        nproc     8192"        >>    /etc/security/limits.conf    # hard for enforcing hard limits
echo "*           soft        nofile    8192"        >>    /etc/security/limits.conf    # nofile – max number of open files 
echo "*           hard        nofile    8192"        >>    /etc/security/limits.conf






printf "\n -------------------------------------------------"
printf "\n  Extended the sysctl.conf. We have modified minimal parameters, please change it as per the requirement."
printf "\n -------------------------------------------------\n"

echo "fs.file-max = 65535" >> /etc/sysctl.conf  #The maximum number of file handles
echo "net.ipv4.ip_nonlocal_bind=1" >> /etc/sysctl.conf #In order for the Keepalived service to forward network packets properly to the real servers, each router node must have IP forwarding turned on in the kernel.

echo "net.ipv4.tcp_tw_reuse=1" >> /etc/sysctl.conf #
echo "net.ipv4.ip_local_port_range = 1024 65023" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 60000" >> /etc/sysctl.conf

echo "##### required to support high connection rate (and better support SYN floods attacks)" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_tw_buckets = 400000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_orphans = 60000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_synack_retries = 3" >> /etc/sysctl.conf
echo "net.core.somaxconn = 5000" >> /etc/sysctl.conf

echo "########" >> /etc/sysctl.conf
echo "net.ipv4.tcp_timestamps = 0" >> /etc/sysctl.conf
echo "net.ipv4.tcp_sack =1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 1"  >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1"  >> /etc/sysctl.conf

sysctl  -p # List the parameters changed.



echo -e  "File limt exceeded and changed in sysctl.conf"

printf "\n  List of packages installed  "

sleep 5

yum list installed   

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

read -p "Please enter List of packages to be uninstalled separated by space: " package_names

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

for package in $package_names
do
echo $package
yum remove $package -y
done






###dpkg --list
###apt-get remove packageName

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

printf "\n Keep Linux Kernel and Software Up to Date"

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

yum update -y

###   apt-get update && apt-get upgrade
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n  Linux User Accounts and Strong Password Policy applied,"
printf "\n  -	Includes at least 8 characters long,  "
printf "\n  -	Mixture of alphabets, number, special character, upper & lower alphabets etc. "
printf "\n  -	Most important pick a password you can remember. "
printf "\n  -	Use tools such as “passwordmeter” to find out weak users passwords on your server."
printf "\n -------------------------------------------------\n"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

authconfig --passminlen=8 --passminclass=4 --passmaxrepeat=2 --enablerequpper --enablereqlower --enablereqdigit --enablefaillock --update

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n  -	we have kept  "
printf "\n  -	deny=5 – Deny access if tally for this user exceeds 5 times. "
printf "\n  -	unlock_time=21600 – Allow access after 21600 seconds (6 hours) after failed attempt. If this option is used the user will be locked out for the specified amount of time after he exceeded his maximum allowed attempts. Otherwise the account is locked until the lock is removed by a manual intervention of the system administrator. "
printf "\n  -	onerr=fail – If something weird happens (like unable to open the file), return with PAM_SUCESS if onerr=succeed is given, else with the corresponding PAM error code."
printf "\n -------------------------------------------------\n"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

echo "auth required pam_tally.so onerr=fail deny=5 unlock_time=21600"  >> /etc/pam.d/system-auth


printf "\n  -  Accounts which Have UID Set To 0"

awk -F: '($3 == "0") {print}' /etc/passwd

sleep 5

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n  -  Ideally only root users should have UID Set To 0,"
read -p "\n  -  Enter List of users that should not have UID Set To 0 from above list separated by space: " user

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

for usr in $user
do
echo $usr
sed -i "s/^[^#]*$usr:x:0:0/#&/" /etc/passwd	
done


printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

read -p "\n  -  Enter List of unwanted services to be disabled separated by space: " service_name_rhel

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"

for service_rhel in $service_name_rhel
do
echo $service_rhel
systemctl stop $service_rhel
systemctl disable $service_rhel

done



printf "Verify No Accounts Have Empty Passwords and If found something then user will be locked."
awk -F: '($2 == "") {print}' /etc/shadow > accountName
accountName_new=`cat accountName`
passwd -l "$accountName_new"

###	All SUID/SGID bits enabled file can be misused when the SUID/SGID executable has a security problem or bug. 
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "You need to investigate each reported file"
printf "All set user id files; "
find / -perm +4000
printf "All set group id files; "
find / -perm +2000

printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"
printf "\n -------------------------------------------------"



printf "find out who changed or accessed a file /etc/passwd"

ausearch -f /etc/passwd 

printf "\n -------------------------------------------------"
printf "\n  Cron secure and file  "
printf "\n -------------------------------------------------\n"

touch /etc/cron.allow
touch /etc/cron.deny
echo "ALL" > /etc/cron.deny

printf "\n -------------------------------------------------"
printf "\n  Take a backup of secure binary file  "
printf "\n -------------------------------------------------\n"

mkdir -p /opt/software/secrue_bkpfile/
find /bin/ -type f -print0 | xargs -0 md5sum > /opt/software/secrue_bkpfile/bin_backup.md5           
find /sbin/ -type f -print0 | xargs -0 md5sum > /opt/software/secrue_bkpfile/sbin_backup.md5         
find /usr/bin/ -type f -print0 | xargs -0 md5sum > /opt/software/secrue_bkpfile/usr_bin_backup.md5   
find /usr/sbin/ -type f -print0 | xargs -0 md5sum > /opt/software/secrue_bkpfile/usr_sbin_backup.md5 

printf "\n -------------------------------------------------"
printf "\n  Take a backup of secure binary file  "
printf "\n -------------------------------------------------\n"

printf "\n  Rebooting the server.  "

reboot

###################### The Hardning Script END ###################