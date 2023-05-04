#!/bin/bash
COMPONENT=mysql
source component/common.sh

echo -n "configuring the repo:"
curl -s -L -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>> $LOGFILE
stat $?

echo -n "installing mysql:"
yum install mysql-community-server -y &>> $LOGFILE
stat $?

echo -n "starting $COMPONENT service:"
systemctl enable mysqld && systemctl start mysqld
stat $?
# && this symbol is use for{expression1 && expression} 
# if the expression1 is exicuted then only the expression2 will be exicuted



