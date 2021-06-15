#!/bin/bash

source components/common.sh
rm -f /tmp/Roboshop.log

HEAD "install nodejs"
yum install nodejs make gcc-c++ -y &>>/tmp/Roboshop.log
STAT $?

HEAD "add roboshop app user"
id Roboshop &>>/tmp/Roboshop.log
if [ $? -eq 0 ];then
  echo user is already there, so skipping the user creation &>>/tmp/Roboshop.log
  STAT $?
else
  useradd Roboshop &>>/tmp/Roboshop.log
STAT $?
fi

HEAD "download app from github"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>/tmp/Roboshop.log
STAT $?

HEAD "extract the dowloded archive"
cd /home/Roboshop && rm -rf Catalogue && unzip /tmp/catalogue.zip &>>/tmp/Roboshop.log && mv catalogue-main Catalogue
STAT $?

HEAD "install nodejs dependencies"
cd /home/Roboshop/Catalogue && npm install --unsafe-perm &>>/tmp/Roboshop.log
STAT $?

HEAD "fix the permission to app content"
chown Roboshop:Roboshop /home/Roboshop -R
STAT $?

HEAD "setup systemD service"
sed -i -e 's/MONGO_DNSNAME/mongodb.ansible/' /home/Roboshop/Catalogue/systemd.service && mv /home/Roboshop/Catalogue/systemd.service
  /etc/systemd/system/Catalogue.service
STAT $?

HEAD "start catalogue service"
systemctl daemon-reload && systemctl enable Catalogue &>>/tmp/Roboshop.log && systemctl restart Catalogue &>>/tmp/Roboshop.log
STAT $?






