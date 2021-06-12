#!/bin/bash

source components/common.sh
rm -f /tmp/Roboshop.log

HEAD "installing nginx"
yum install nginx -y &>>/tmp/Roboshop.log
STAT $?






