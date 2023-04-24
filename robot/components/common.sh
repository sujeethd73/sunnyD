LOGFILE=/tmp/$COMPONENT.log


USERID=$(id -u)

if [ $USERID -ne 0 ] ; then
  echo -e "\e[31m you must have to run this script as a room user or sudo previlage \e[0m"
  exit 1
fi

stat() {
if [ $1 -eq 0 ]; then
  echo -e "\e[32m success \e[0m"
else  
  echo -e "\e[31m failure \e[0m"
fi
} 