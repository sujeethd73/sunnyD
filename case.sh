#!/bin/bash

ACTION=$1

case $ACTION in
   start)
       echo "starting xyz service"
       ;;
    stop)
       echo "stoping xyz service"
       ;;
    *)
        echo "\e[31m valid options are either start or stop \e[0m"

esac