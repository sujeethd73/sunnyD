#!/bin/bash
set -e

COMPONENT=frontend

source components/common.sh

echo -n "installing nginx:"

yum install nginx -y &>> $LOGFILE
stat $?


echo -n "downloading the component:"

curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "performing the cleaning up:"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
stat $?

cd /usr/share/nginx/html
echo -n "unzipping the component:"

unzip /tmp/$COMPONENT.zip &>> $LOGFILE
stat $?

mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
echo -n "configuring the revers proxy file:"

mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "starting the server:"
systemctl enable nginx &>> $LOGFILE
systemctl restart nginx &>> $LOGFILE
stat $?


