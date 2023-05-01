##!/bin/bash

COMPONENTS=user

source components/common.sh
APPUSER=roboshop

echo -n "configuring the nodejs repo:"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
stat $?

echo -n "installing nodejs:"
yum install nodejs -y &>> $LOGFILE
stat $?

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ] ; then
echo -n "careating app user:"
useradd roboshop &>> $LOGFILE
stat $?
fi

echo -n "downloading the component:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "moving $COMPONENT code to $APPUSER home directory:"
cd /home/$APPUSER 
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
stat $?

echo -n "performing cleanup:"
rm -rf $COMPONENT
stat $?

echo -n "installing nodejs dependency:"
npm install &>> $LOGFILE
stat $?

echo -n "installing nodejs component:"
cd $COMPONENT
stat $?

echo -n "changing permissions to $APPUSER:"
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT && chmod -R 775 /home/roboshop/$COMPONENT
stat $?

echo -n "configuring $COMPONENT service:"
sed -i -e 's/MONGO-DNSNAME/174.12.54.45/' /home/roboshop/$COMPONENT/systemd.service
 mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "starting the $COMPONENT service:"
systemctl daemon-reload &>> $LOGFILE
systemctl start $COMPONENT &>> $LOGFILE
systemctl enable $COMPONENT &>> $LOGFILE
stat $?

echo -e "/e[33m_________$COMPONENT installation completed_________/e[0m"



