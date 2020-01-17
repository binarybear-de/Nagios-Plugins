#!/bin/bash

###### Written by Brayden Santo for Nagios to check the last recording time of videos cameras.
###### This script uses JSON parsing to pull a single variable from the Unifi Video system through the Admin API.
###### It depends on the small 'jq' parsing package, so you'll need to install that first.

###### Instructions:
###### Change the warning and critical values to match what your environment requires
###### Change the address of the curl address to be the address of your UniFi Video camera system
###### Generate an API key in your UniFi Video System and put it in the curl URL below

#####Variable Init
cameraMAC=$1
jq="/usr/local/nagios/bin/jq"
cameraName=$()
cameraLastRecordingStartTime=$()
warningValue=$(date -d '-48 hours' '+%s')   #Epoch time for no recording in the last 48 hours
criticalValue=$(date -d '-96 hours' '+%s')  #Epoch time for no recording in the last 96 hours

#####Curl the URL to get the epoch time data and camera name
cameraName=$(curl -k -s "http://<yourserver>:<yourport>/api/2.0/camera?apiKey=<yourAPIkey>&mac=${cameraMAC}" | ${jq} '.data[].name')
cameraLastRecordingStartTime=$(curl -k -s "http://<yourserver>:<yourport>/api/2.0/camera?apiKey=<yourAPIkey>&mac=${cameraMAC}" | ${jq}  '.data[].lastRecordingStartTime')

#####Divide the time data by 1000 to get accurate human time
lastRecordingEpochTimeInSeconds=$(expr $cameraLastRecordingStartTime / 1000)

######Compare time to decide to flag in Nagios
humanTime=$(date -d @"$lastRecordingEpochTimeInSeconds")

######If last recording time more than critical time, flag and out as critcal with name and last recording time
if [ "$lastRecordingEpochTimeInSeconds" -lt "$criticalValue" ]
then
echo 'Last Recording: '$humanTime 'on' $cameraName 'is more than 96 hours ago'
exit 2

######If last recording time less than critical time, but more than normal time, flag and out as warning with name and last recording time
elif [ "$lastRecordingEpochTimeInSeconds" -lt "$warningValue" -a "$lastRecordingEpochTimeInSeconds" -gt "$criticalValue" ]
then
echo 'Last Recording: '$humanTime 'on' $cameraName 'is more than 48 hours ago but less than 96 hours.'
exit 1

######If okay, out as okay and last recording time
elif [ "$lastRecordingEpochTimeInSeconds" -gt "$warningValue" ]
then
echo 'Last Recording: '$humanTime 'on' $cameraName 'is okay.'
exit 0

#####Exit as Unknown if something else happens...
else
echo 'Something else happened, script failed.'
exit 3
fi
