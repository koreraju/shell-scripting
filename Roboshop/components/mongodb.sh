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

HEAD "update listen address in config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
STAT $?

HEAD "start mongoDB service"
systemctl enable mongod &>>/tmp/Roboshop.log
systemctl restart mongod &>>/tmp/Roboshop.log
STAT $?

HEAD "download schema from Github"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>/tmp/Roboshop.log
STAT $?

HEAD "extract download archive"
cd /tmp
unzip -o mongodb.zip &>>/tmp/Roboshop.log
STAT $?

HEAD "load schema"
cd mongodb-main
mongo < catalogue.js &>>/tmp/Roboshop.log && mongo < users.js &>>/tmp/Roboshop.log
STAT $?




