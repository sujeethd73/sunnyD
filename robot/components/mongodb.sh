#!/bin/bash
set -e

# verify the script is been executed as root user or not

COMPONENT=mongodb

source components/common.sh

echo -n "configuring the repo:"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "installing mongodb:"
yum install -y mongodb-org &>> $LOGFILE
stat $?


