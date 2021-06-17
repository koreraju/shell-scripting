#!/bin/bash

source components/common.sh
rm -f /tmp/Roboshop.log
set-hostname Redis

HEAD "setup Redis Repos"

yum install epel-release yum-utils -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>/tmp/Roboshop.log && yum-config-manager --enable remi &>>/tmp/Roboshop.log
STAT $?
