#!/bin/bash
############# feauture #############
# tail log service
# check status

############# set env #############
# color
GREEN='\e[32m'
RED='\e[31m'
YELLOW='\e[33m'
END_COLOR='\e[0m'

# time
HHMM=$(date +%H%M)
YYYYMMDD=$(date +%Y%m%d)
YYYYMMDD_HM=$(date +%Y%m%d_%H%M)

# file & directory
SERVICE_NAME='discovery service'
SOURCE_NAME=source-current-1
SOURCE_CURRENT=/opt/$SOURCE_NAME
SOURCE_BACKUP=/opt/source-backup/$SOURCE_NAME
SOURCE_NEW=/opt/source-new/$SOURCE_NAME
SOURCE_FILE=Termius.deb

# group & user
USER=linux
GROUP=linux

############# run code #############
# check if the script is run by the 'psp' user
if [ $(whoami) != $USER ]; then
    echo "$RED You must run this script with '$USER' user. $END_COLOR"
    exit 1
fi

# check new source code exist
if [ -f $SOURCE_NEW/$YYYYMMDD/$SOURCE_FILE ]; then
    # check & create backup directory
    if [ -d $SOURCE_BACKUP/$YYYYMMDD ]; then
        echo "$GREEN Rename the current backup file. $END_COLOR"
        mv $SOURCE_BACKUP/$YYYYMMDD/$SOURCE_FILE $SOURCE_BACKUP/$YYYYMMDD/$SOURCE_FILE.$HHMM
        sleep 2
    else
        mkdir -p $SOURCE_BACKUP/$YYYYMMDD
    fi

    # deploy
    echo "$GREEN Deploy $SERVICE_NAME: Begin. $END_COLOR"

    echo "---> Backup source code."
    mv $SOURCE_CURRENT/$SOURCE_FILE $SOURCE_BACKUP/$YYYYMMDD/
    sleep 2

    echo "---> Copy new source."
    cp $SOURCE_NEW/$YYYYMMDD/$SOURCE_FILE $SOURCE_CURRENT/$SOURCE_FILE
    sleep 2

    echo "$GREEN Deploy $SERVICE_NAME: Done. $END_COLOR" 
else
    echo "$RED New source not found! $END_COLOR"
fi