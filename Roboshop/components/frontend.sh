#!/bin/bash

source components/common.sh
rm -f /tmp/Roboshop.log

Head "installing nginx"
yum install nginx -y &>>/tmp/Roboshop.log
stat $?




