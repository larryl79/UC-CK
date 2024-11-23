#!/bin/bash
#############################################
#
# Unifi UC-CK Cloudkey Gen 1 LED control
#
# ver 0.1 (creditor original)
#
# Credits: https://community.ui.com/stories/Repurposing-a-second-UniFi-Cloud-Key-as-a-DNS-Recursor-Radius-and-NTP-server/56605e0f-401f-4397-8c05-5b1cbe118bf6
#
#############################################


if [ "$1" == "blue" ]; then
 echo "Enabling steady blue LED"
 echo 0 > /sys/class/leds/white/brightness
 echo 255 > /sys/class/leds/blue/brightness


elif [ "$1" == "white" ]; then
  echo "Enabling flashing white LED"
  echo 0 > /sys/class/leds/blue/brightness
  echo timer > /sys/class/leds/white/trigger
  echo 750 > /sys/class/leds/white/delay_off
  echo 750 > /sys/class/leds/white/delay_on

else echo "ERROR: Unrecognized led $1"

exit 3
fi

