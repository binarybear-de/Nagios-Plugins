## Features
* Shows device's state (connected or not)
* Shows last recording timestamp
* configurable thresholds for last recording's age
* Shows firmware as well as whetcher newer firmware is avaiable and displays that
* Supports multiple cameras (no autodiscovery yet...)

## What's different?
This script was forked from https://github.com/chooko/Nagios-Plugins. Main goal was to convert the Nagios script to Check_MK and adding multi-cam support as well. Requests have been reduced to one per camera instead of one per metric.

## Requirements 

* UniFi Video NVR (tested on Debian 9.12, UniFi-Video 3.10.11)
* Check_MK Agent (Tested on 1.6.0p12)
* Package jq installed (```apt install jq```)

## Installation

Move the ```check_unifi-cameras.sh``` into the local dir ```/usr/lib/check_mk_agent/local```. Create a API-Key in UniFi-Video's User-Management. Ideally create a dedicated view-only user in UniFi-Video for this task.
You'll need to att your camera's MAC addresses into the Array - there's no auto-detection.

### Sample Output

Running the script should give you something like this:
```
0 Camera-TEST1 - Disconnected!, Last Recording: Tue Jun  9 19:54:12 CEST 2020
0 Camera-TEST2 - Connected, Last Recording: Tue Jun  9 19:57:10 CEST 2020
```
