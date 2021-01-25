## Features
* Shows device's state (connected or not)
* Shows last recording timestamp
* configurable thresholds for last recording's age
* Supports multiple cameras (no autodiscovery yet...)
* tested with UniFi-Video 3.10.11

## What's different?
This script was forked from https://github.com/chooko/Nagios-Plugins.
* adapted the Nagios script to Check_MK
* added multi-cam support
* reduced Requests to one per camera instead of one per metric per camera.

## Installation / Setup

### One-liner
The I-am-lazy-just-install method: Just copy-paste the whole block in the shell on Debian-based systems
```
apt install jq curl wget -y \
&& CMK_LOCAL=/usr/lib/check_mk_agent/local/check_unifi-video.sh \
&& CMK_CONFIG=/etc/check_mk/unifi-nvr.cfg \
&& wget https://raw.githubusercontent.com/binarybear-de/cmk_check_unifi-video/master/check_unifi-video.sh -O $CMK_LOCAL \
&& chmod +x $CMK_LOCAL \
&& wget https://raw.githubusercontent.com/binarybear-de/cmk_check_unifi-video/master/unifi-nvr.cfg -O $CMK_CONFIG \
&& chmod 700 $CMK_CONFIG \
&& chown root: $CMK_CONFIG \
&& unset CMK_LOCAL CMK_CONFIG
```

### updating
```
CMK_LOCAL=/usr/lib/check_mk_agent/local/check_unifi-video.sh \
&& https://raw.githubusercontent.com/binarybear-de/cmk_check_unifi-video/master/check_unifi-video.sh -O $CMK_LOCAL \
&& chmod +x $CMK_LOCAL \
&& unset CMK_LOCAL
```

### manual
Install Check_MK-Agent, curl and jq package (```apt install jq curl```)
Move the ```check_unifi-cameras.sh``` into the local dir ```/usr/lib/check_mk_agent/local```. Create a API-Key in UniFi-Video's User-Management. Ideally create a dedicated view-only user in UniFi-Video for this task.
You'll need to att your camera's MAC addresses into the Array - there's no auto-detection.

### Sample Output
Running the script should give you something like this:
```
0 Camera-TEST1 - Disconnected!, Last Recording: Tue Jun  9 19:54:12 CEST 2020
0 Camera-TEST2 - Connected, Last Recording: Tue Jun  9 19:57:10 CEST 2020
```
