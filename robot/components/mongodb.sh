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

echo -n "chainging the ip address:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?


echo -n "starting the mongodb"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
stat $?

echo -n "download the schema:"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "injecting the schema:"
 cd /tmp
unzip mongodb.zip
cd mongodb-main
mongo < catalogue.js
mongo < users.js
stat $?
