#!/bin/bash

disable-auto-shutdown

HEAD() {
  echo -n -e "\e[1m $1 \e[0m \t\t ... "
}

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32m done\e[0m"
  else
    echo -e "\e[1;31m fail\e[0m"
    echo -e "\e[1;33m Check the log for more detail ... Log-File : /tmp/Roboshop.log\e[0m"
    exit 1
  fi
}

APP_USER_ADD(){
  HEAD "add roboshop app user"
id Roboshop &>>/tmp/Roboshop.log
if [ $? -eq 0 ];then
  echo user is already there, so skipping the user creation &>>/tmp/Roboshop.log
  STAT $?
else
  useradd Roboshop &>>/tmp/Roboshop.log
STAT $?
fi
}

NODEJS() {
  HEAD "install nodejs"
yum install nodejs make gcc-c++ -y &>>/tmp/Roboshop.log
STAT $?

APP_USER_ADD

HEAD "download app from github"
curl -s -L -o /tmp/$1.zip "https://github.com/roboshop-devops-project/$1/archive/main.zip" &>>/tmp/Roboshop.log
STAT $?

HEAD "extract the downloded archive"
cd /home/Roboshop && rm -rf $1 && unzip /tmp/$1.zip &>>/tmp/Roboshop.log && mv $1-main $1
STAT $?

HEAD "install nodejs dependencies"
cd /home/Roboshop/$1 && npm install --unsafe-perm &>>/tmp/Roboshop.log
STAT $?

HEAD "fix the permission to app content"
chown Roboshop:Roboshop /home/Roboshop -R
STAT $?

HEAD "setup systemD service"
sed -i -e 's/MONGO_DNSNAME/mongodb.ansible/' /home/Roboshop/$1/systemd.service && mv /home/Roboshop/$1/systemd.service /etc/systemd/system/$1.service
STAT $?

HEAD "start $1 service"
systemctl daemon-reload && systemctl enable $1 &>>/tmp/Roboshop.log && systemctl restart $1 &>>/tmp/Roboshop.log
STAT $?
}



