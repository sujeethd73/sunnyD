#!/bin/bash
set -e

# verify the script is been executed as root user or not
USERID=$(id -u)
if [ $USERID -ne 0 ] ; then
  echo -e "\e[31m you must have to run this script as a room user or sudo previlage \e[0m"
  exit 1
fi
echo "installing nginx:" 
yum install nginx -y &>> /tmp/frontend.log
if [ $? -eq 0 ]: then
  echo -n "\e[32m success \e[0m"
  echo -n "\e[31m failure \e[0m"
fi 

echo "downloading the component:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

echo "performing the cleaning up:"
rm -rf/usr/share/nginx/html/* &>> /tmp/frontend.log*  
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> /tmp/frontend.log
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx &>> /tmp/frontend.log
systemctl start nginx &>> /tmp/frontend.log