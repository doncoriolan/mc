#!/bin/bash
# script to troubleshoot an IP or Domain 

INPUTBOX=${INPUTBOX=dialog}
TITLE="Default"
MESSAGE="Something to display"
XCOORD=10
YCOORD=20
#GOOD=0
#BAD=1

# function start
funcDisplayInputBox () {
    $INPUTBOX --title "$1" --inputbox "$2" "$3" "$4" 2>tmpfile.txt
}
# function stop

# function start 
funcDisplayInfoBox () {
    $INPUTBOX --cr-wrap --title "$1" --infobox "$2" "$3" "$4"
    sleep "$5"
}
# function stop

# ping script start

clear

funcDisplayInputBox "Troubleshooter" "What device would you like to troubleshoot?" "10" "20"

if [ "`cat tmpfile.txt`" != "" ]; then
  ping -c 5 "`cat tmpfile.txt`"
else
  funcDisplayInputBox "Error!" "Please enter a IP or Domain" "10" "20"
fi

#RETURN_VALS=$?
# if the ping is successfull spit out a success message
if [ "$?" -eq "0" ]; then
  funcDisplayInfoBox "Success!" "We can ping the device" "10" "20" "5"
else
  funcDisplayInfoBox "Error!" "Device unreachable" "10" "20" "5"
fi
rm -f tmpfile.txt
# ping part ends here
clear
# netcat part starts here
funcDisplayInputBox "Troubleshooter" "Netcat Connection Test" "10" "20"

if [ "`cat tmpfile.txt`" != "" ]; then
  timeout --preserve-status 5 nc -v -w 5 "`cat tmpfile.txt`"

else
  funcDisplayInputBox "Error!" "Please enter a IP or Domain and port" "10" "20"
fi

if [ "$?" -eq "143" ]; then
  funcDisplayInfoBox "Success!" "We can connect to the device" "10" "20" "5"
else
  funcDisplayInfoBox "Error!" "Device unreachable" "10" "20" "5"
fi
