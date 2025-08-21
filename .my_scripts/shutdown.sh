#!/bin/bash

zenity --warning --text="Shutdown in 3 minutes"
notify-send "Nightly shutdown!!!" "Shutdown in 3 minutes!"
sleep 180
/sbin/shutdown -P now
