#!/bin/bash
set -e

COMPONENT=redis
source components/common.sh

echo -n "configuring the repo:"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOGFILE
stat $?

echo -n "installing redis:"
yum install redis-6.2.11 -y &>> $LOGFILE
stat $?

echo -n "whitelisting redis to others:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?

echo -n "starting the $COMPONENT:"
systemctl daemon-reload redis
systemctl start redis
stat $?

# check the status of the component in xshell meachine.



