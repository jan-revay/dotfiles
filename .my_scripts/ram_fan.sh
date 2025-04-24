#!/bin/bash -x

# Exit if not running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

set_fan_speed() {
    echo "$1" | tee /sys/class/hwmon/hwmon0/pwm6 > /dev/null
    echo "fan6 (RAM fan) speed was set to $1"
}

# Ensure fan control is enabled
echo 1 | tee /sys/class/hwmon/hwmon0/pwm6_enable

while true; do
    DIMM_TEMP=$(sensors -j | jq '[.["spd5118-i2c-1-53"].temp1.temp1_input, .["spd5118-i2c-1-51"].temp1.temp1_input] | max')
    
    echo "DIMM_TEMP=$DIMM_TEMP"
    
    if (( $(echo "$DIMM_TEMP < 33" | bc -l) )); then
        set_fan_speed 160
    elif (( $(echo "$DIMM_TEMP < 38" | bc -l) )); then
        set_fan_speed 180
    elif (( $(echo "$DIMM_TEMP <= 42" | bc -l) )); then
        set_fan_speed 200
    else
        set_fan_speed 256
    fi
    
    if (( $(echo "$DIMM_TEMP > 49" | bc -l) )); then
        echo "CRITICAL: DIMM temperature too high ($DIMM_TEMP °C) — shutting down in 1 minute!"
        shutdown -h +1 "CRITICAL: DIMM temperature exceeded 49°C — system will shut down in 1 minute."
    fi

    sleep 1
done
