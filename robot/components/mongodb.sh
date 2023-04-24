#!/bin/bash

set -e

# verify the script is been executed as root user or not
USERID=$(id -u)
COMPONENT=mongodb
LOGFILE=/tmp/$COMPONENT.log


if [ $USERID -ne 0 ] ; then
  echo -e "\e[31m you must have to run this script as a room user or sudo previlage \e[0m"
  exit 1
fi

stat() {
if [ $1 -eq 0 ]; then
  echo -e "\e[32m success \e[0m"
else  
  echo -e "\e[31m failure \e[0m"
fi
} 

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
systemctl start nginx &>> $LOGFILE
stat $?
