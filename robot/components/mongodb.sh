#!/bin/bash
set -e

# verify the script is been executed as root user or not

COMPONENT=mongodb

source components/common.sh

echo -n "configuring the repo:"
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo
stat $?

echo -n "installing ${COMPONENT}:"
yum install -y mongodb-org &>> $LOGFILE
stat $?

echo -n "starting the mongodb"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
stat $?


