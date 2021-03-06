#!/bin/bash
# script to list all UniFi Video cameras from the given controller and get some infos
# https://github.com/binarybear-de/cmk_check_unifi-video
SCRIPTBUILD="BUILD 2021-01-24"

###############################################################
# you should not need to edit anything here - use the config file!
###############################################################

CONFIG_FILE=/etc/check_mk/unifi-nvr.cfg
CONFIG_ACCESS=$(stat -c %a $CONFIG_FILE)
CONFIG_OWNER=$(stat -c %U $CONFIG_FILE)

if [ ! $CONFIG_ACCESS = 700 ] || [ ! $CONFIG_OWNER = root ] ; then
	echo "Config permission mismatch, must be 700 with owner root (current: $CONFIG_ACCESS, owner $CONFIG_OWNER)!"
	exit 1
fi

# source the settings from file
. $CONFIG_FILE

#Translate thresholds in seconds
WARN=$(date -d "-$WARN_HOURS hours" '+%s')
CRIT=$(date -d "-$CRIT_HOURS hours" '+%s')

#set UNKNOWN STATE if script is interrupted for some reason
STATE=3

#do a for-loop for all MAC addresses

getDeviceInfo() {
	echo $CURL_RESPONSE | jq ".data[].$1"
}

###############################################################

for mac in "${MAC_LIST[@]}"; do

	# request JSON from API
	CURL_RESPONSE=$(curl -k -s "https://${ADDRESS}/api/2.0/camera?apiKey=${API_KEY}&mac=${mac}")

	# get some infos
	CAM_NAME=$(getDeviceInfo name)
	CAM_LAST_REC=$(expr $(getDeviceInfo lastRecordingStartTime) / 1000)
	CAM_LAST_REC_HUMAN=$(date -d @"$CAM_LAST_REC")
	CAM_STATE=$(getDeviceInfo state)

	# Longer ago than CRIT
	if [ "$CAM_LAST_REC" -lt "$CRIT" ]; then
		DESCRIPTION="Last Recording: $CAM_LAST_REC_HUMAN on $CAM_NAME is more than $CRIT_HOURS hours ago!"
		STATE=2

	# Longer ago then WARN but less ago then CRIT
	elif [ "$CAM_LAST_REC" -lt "$WARN" -a "$CAM_LAST_REC" -gt "$CRIT" ]; then
		DESCRIPTION="Last Recording: $CAM_LAST_REC_HUMAN on $CAM_NAME is more then $WARN_HOURS hours ago!"
		STATE=1

	# Less ago than WARN
	elif [ "$CAM_LAST_REC" -gt "$WARN" ]; then
		DESCRIPTION="Last Recording: $CAM_LAST_REC_HUMAN"
		STATE=0

	# Exit as Unknown if something else happens...
	else
		DESCRIPTION="Something else happened, script failed."
		STATE=3
	fi

	# Check if CAM is connected
	if [ "$CAM_STATE" == '"CONNECTED"' ]; then
		DESCRIPTION="Connected, $DESCRIPTION"
	elif [ "$CAM_STATE" == '"DISCONNECTED"' ]; then
		DESCRIPTION="Disconnected!, $DESCRIPTION"
		STATE=2
	else
		DESCRIPTION="Unknown State: $CAM_STATE, $DESCRIPTION"
		STATE=2
	fi

	echo "$STATE Camera-${CAM_NAME//\"} - $DESCRIPTION"
done
