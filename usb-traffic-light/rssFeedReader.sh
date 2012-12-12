#!/bin/sh

# This script is used to control a USB Traffic Light from Cleware. You can buy 
# the USB Traffic Light from this shop: http://www.cleware-shop.de
# 
# The script uses the RSS FeedReader and can be used for older versions of Jenkins.
# In newer Versions of Jenkins, you can call the REST API to get the detailed
# information of every job.
#
# Requirements:
# 
#   The Cleware USB Traffic Light comes with a Control Software that you can 
#   download from the Cleware Website. 
#
#   This script can be run under Windows using a cygwin shell. You need to
#   have "curl" installed, so the script can poll the RSS Feed from the
#   Jenkins Job that you want to monitor.
#
#   This script has been tested under Windows running cygwin and Cleware4.2.8
#
# @MarcelBirkner
# 

cd Cleware4.2.8/

# configure Jenkins Job + User/Password
URL="http://<jenkins>:8080/view/My%20Jobs/rssLatest"
CREDENTIALS=user:password

# Configure Script and time interval
TIME=1
COMMAND=./USBswitchCmd.exe

# Loop that checks the Jenkins Job RSS Feed and updates the traffic light state
while true; do 

	state=`curl -u $CREDENTIALS $URL | sed 's/></>\n</g' | grep "<title>VisionLink-CI" | sed 's/(/ | /g' | sed 's/)/ | /g' | awk '{print $4}'`
	
	case $state in 
	    ?) echo "Building "`date`; $COMMAND Y; sleep $TIME; $COMMAND G; sleep $TIME;;
	    stable) echo "Stable "`date`; $COMMAND G; sleep 5;;
	    back) echo "Back to stable "`date`; $COMMAND G; sleep 5;;
	    *) echo "Instable "`date`; $COMMAND R; sleep 5;;
	esac;
	
done;
