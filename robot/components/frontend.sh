#!/bin/bash

# verify the script is been executed as root user or not
USERID=$(id -u)
if [ USERID -ne 0 ] ; then
    echo "\e[31m you must have to run this script as a room user or sudo previlage \e[0m"
fi 
 yum install nginx -y
