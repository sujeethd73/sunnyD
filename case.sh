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
        echo "valid options are either start or stop"

esac