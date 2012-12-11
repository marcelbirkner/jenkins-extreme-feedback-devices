#!/bin/sh

# This script is used to control a USB Traffic Light from Cleware. You can buy 
# the USB Traffic Light from this shop: http://www.cleware-shop.de
# 
# The script uses the REST API and can be used for newer versions of Jenkins.
#
# Requirements:
# 
#   The Cleware USB Traffic Light comes with a control software that you can 
#   download from http://www.vanheusden.com/clewarecontrol/ 
#
#   This script can be run under Linux. You need to have "curl" installed, 
#   so the script can poll the REST API.
#
#   This script has been tested under Ubuntu and clewarecontrol 2.0
#
# @MarcelBirkner
# 

USER=user
PASSWORD=password
JENKINS_SERVER=http://<jenkins>:8080/job/
JOB_NAME=Extreme%20Feedback%20Device%20Test
DEVICE_NO=<USB device number>

# Methods for controlling the device
gOn() {
  clewarecontrol -c 1 -b -d $DEVICE_NO -as 2 1 2>&1 
}
gOff() {
  clewarecontrol -c 1 -b -d $DEVICE_NO -as 2 0 2>&1 
}
yOn() {
  clewarecontrol -c 1 -b -d $DEVICE_NO -as 1 1 2>&1 
}
yOff() {
  clewarecontrol -c 1 -b -d $DEVICE_NO -as 1 0 2>&1 
}
rOn() {
  clewarecontrol -c 1 -b -d $DEVICE_NO -as 0 1 2>&1 
}
rOff() {
  clewarecontrol -c 1 -b -d $DEVICE_NO -as 0 0 2>&1 
}


while true; do 
  color=`curl -silent -u $USER:$PASSWORD $JENKINS_SERVER$JOB_NAME/api/json?pretty=true | grep color `
  state=`echo $color | sed 's/\"//g' | sed 's/,//g' | awk '{print $3}'` 
  echo $state;  
  case $state in 
    red) echo "red"; rOn; yOff; gOff;;
    yellow) echo "yellow"; rOff; yOn; gOff;;
    blue) echo "blue"; rOff; yOff; gOn;; 
    red_anime) echo $state; rOff; yOff; gOff;    sleep 1; rOn; sleep 1; rOff; sleep 1; rOn;;
    yellow_anime) echo $state; rOff; yOff; gOff; sleep 1; yOn; sleep 1; yOff; sleep 1; yOn;;
    blue_anime) echo $state; rOff; yOff; gOff;   sleep 1; yOn; sleep 1; yOff; sleep 1; yOn;;
    *) echo "nothing matched "$state;;  
  esac;

  sleep 1;  
done;

