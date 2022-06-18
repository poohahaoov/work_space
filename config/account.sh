#!/bin/bash
clear
useradd -D -s /bin/bash
######################################
echo "################################"
echo "#### account create for IDC ####"
echo "################################"
echo -e "\n"
######################################
read -p "UserName> " username
read -p "User ID
 > " userid
read -p "uid > " uid
echo -e "\n"
######################################
#useradd -m -k /etc/skel ${userid} -u ${uid} -b ${home} -s /bin/bash -c ${userName}
useradd -m -u ${uid} -c ${username} ${userid}
echo "${userid}:Pa55w0rd" | chpasswd
usermod -aG docker ${userid}
######################################

echo "################################"
echo "####      account info      ####"
echo "################################"
echo -e "\n"
cat /etc/passwd | tail -1
id ${userid}
chage --lastday 0 ${userid}