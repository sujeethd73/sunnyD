#!/bin/bash

COMPONENTS=catalogue

source components/common.sh
APPUSER=roboshop

echo -n "configuring the nodejs repo:"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
stat $?

echo -n "installing nodejs:"
yum install nodejs -y &>> $LOGFILE
stat $?

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ]; then
echo -n "careating app user:"
useradd roboshop &>> $LOGFILE
exit 1
stat $?
fi

echo -n "downloading the component:"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?

echo -n "moving $COMPONENT code to $APPUSER home directory:"
cd /home/$APPUSER 
unzip -o /tmp/catalogue.zip &>> $LOGFILE
stat $?

echo -n "performing cleanup:"
rm -rf $COMPONENT
stat $?

echo -n "installing nodejs component:"
cd $COMPONENT
npm install &>> $LOGFILE
stat $?

echo -n "changing permissions to $APPUSER:"
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT
stat $?






