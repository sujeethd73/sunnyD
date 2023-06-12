#!/bin/bash

ACTION=$1

case $ACTION in
   start)
       echo "starting xyz service"
       exit 0
       ;;
    stop)
       echo "stoping xyz service"
       exit 1
       ;;
    *)
        echo -e "\e[31m valid options are either start or stop \e[0m"
        exit 2

esac


