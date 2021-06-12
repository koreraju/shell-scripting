#!/bin/bash

source components/common.sh
rm -f /tmp/Roboshop.log

HEAD "installing nginx"
yum install nginx -y &>>/tmp/Roboshop.log
STAT $?

HEAD "start nginx\t"
systemctl start nginx &>>/tmp/Roboshop.log
systemctl enable nginx &>>/tmp/Roboshop.log
STAT $?

HEAD "download from github"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/roboshop.log
STAT $?



