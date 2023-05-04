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

NODEJS()  {
  echo -n "configuring the nodejs repositery:"
  curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
  stat $?

  echo -n "installing the nodejs:"
  yum install nodejs -y &>> $LOGFILE
  stat $?

  # calling create_user function
  CREATE_USER
  # downloading the code
  DOWNLOAD_AND_EXTRACT
  #performing npm install
  NPM_INSTALL
  #CONFIGURING THE SERVICE
  CONFIGURE_SERVICE
}

CREATE_USER()  {
  id $APPUSER &>> $LOGFILE
  if [ $? -ne 0 ]; then
    echo -n "careating app user:"
    useradd $APPUSER &>> $LOGFILE
    stat $?
    fi
  }

DOWNLOAD_AND_EXTRACT() {
    echo -n "Downloading the $COMPONENT:"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
    stat $?

    echo -n "performing cleanup:"
    cd /home/$APPUSER
    unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
    stat $?

    echo -n "changing permissions to $APPUSER:"
    chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT-main &>> $LOGFILE
    chmod -R 775 /home/roboshop/$COMPONENT-main &>> $LOGFILE
    stat $?
}

NPM_INSTALL() {
  echo -n "installing $COMPONENT dependencies:"
  mv $COMPONENT-main $COMPONENT
  cd $COMPONENT &>> $LOGFILE
  npm install &>> $LOGFILE
  stat $?
}
CONFIGURE_SERVICE() {
  echo -n "configuring $COMPONENT service:"
  sed -i -e 's/MONGO_DNSNAME/172.31.31.151/' -e 's/REDIS_ENDPOINT/172.31.80.33/' -e 's/CATALOGUE_ENDPOINT/172.31.18.22/' systemd.service &>> $LOGFILE
  stat $?
  echo -n "moving:"
  mv /home/roboshop/$COMPONENT-main/systemd.service /etc/systemd/system/$COMPONENT.service
  stat $?

  echo -n "starting $COMPONENT service:"
  systemctl daemon-reload $COMPONENT &>> $LOGFILE
  systemctl start $COMPONENT &>> $LOGFILE
  stat $?
}




