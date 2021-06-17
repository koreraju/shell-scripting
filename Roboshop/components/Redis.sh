#!/bin/bash

source components/common.sh
rm -f /tmp/Roboshop.log
set-hostname Redis

HEAD "setup Redis Repos"
yum install epel-release yum-utils http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>/tmp/Roboshop.log && yum-config-manager --enable remi &>>/tmp/Roboshop.log
STAT $?

HEAD "install redis"
yum install redis -y &>>/tmp/Roboshop.log
STAT $?

HEAD "update listen address in redis config"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/Redis/redis.conf
STAT $?

HEAD "start redis service"
systemctl enable Redis &>>/tmp/Roboshop.log && systemctl restart Redis &>>/tmp/Roboshop.log
STAT $?




