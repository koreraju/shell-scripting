#!/bin/bash

source components/common.sh
rm -f /tmp/Roboshop.log

HEAD "install nodejs"
yum install nodejs make gcc-c++ -y &>>/tmp/Roboshop.log
STAT $?

HEAD "add roboshop app user"
id Roboshop &>>/tmp/Roboshop.log
if [$? -eq 0 ];then
  echo user is already there, so skipping the user creation &>>/tmp/Roboshop.log
  STAT $?
else
useradd Roboshop &>>/tmp/Roboshop.log
STAT $?

HEAD "download app from github"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>/tmp/Roboshop.log
STAT $?

HEAD "extract the dowloded archive"
cd /home/Roboshop && unzip /tmp/catalogue.zip &>>/tmp/Roboshop.log && mv catalogue-main Catalogue
STAT $?

HEAD "install nodejs dependencies"
cd /home/Roboshop/Catalogue && npm install --unsafe-perm &>>/tmp/Roboshop.log
STAT $?





