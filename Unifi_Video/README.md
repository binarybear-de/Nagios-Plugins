# Check_lastRecordingTime.sh

This is a bash script that runs on my nagios server and goes out to my UniFi Video server to check the Last Recording Start Time field of each camera. It takes the MAC address of the camera and calls the UniFi Video API to pull and parse the JSON returned.

It depends on the small 'jq' package, which is readily available. See https://stedolan.github.io/jq/ for more information.

Once jq is installed, you can run this script by changing "yourserver:yourport" in the shell script to match your UniFi video server. 
You'll also need to generate an API key in your UniFi Video Server that you replace in the curl url of the script.
You may also want to change the warning and critical thresholds to something more appropriate to your environment. 

I've also included a sample service check command, which you have to add into Nagios with the device's MAC address to actually call the API. Hopefully that makes sense.

I also had to change the permissions on the script to allow the nagios user to run it. Simply do a chmod 755 on the file and restart the nagios service.

The code isn't perfect, but gets the job done for what I needed. If you have any issues or quesitons, I'm glad to help as I can. 
This could probably be easily modified to check any number of variables on the cameras. 

Thanks for taking a look!
