#!/bin/bash

source components/common.sh
rm -f /tmp/Roboshop.log

HEAD "setup MongoDB yum repo file\t"
echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
STAT $?

HEAD "install MongoDB\t\t"
yum install -y mongodb-org &>>/tmp/Roboshop.log
STAT $?

HEAD "start mongoDB service"
systemctl enable mongod &>>/tmp/Roboshop.log
systemctl start mongod &>>/tmp/Roboshop.log
STAT $?

HEAD "update listen address in config file"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mongodb.conf
STAT $?


