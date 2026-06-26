#!/bin/bash -x

# resolve the directory where THIS script lives
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/window_calls_prelude.sh"

discord &> /dev/null &
# Open Discord - audio part. This is a workaround around broken audio source
# processing in the Discord desktop app (the audio was stuttering and the latency
# was also terrible otherwise). I connect audio via the PWA in Google Chrome
# and screen-share/video via the Discord desktop app). This is the Discord app
# launched as PWA in chrome.
gtk-launch chrome-magkoliahgffibhgfkmoealggombgknl-Default.desktop &> /dev/null &
sleep 5
discord=$(win_list | jq -c '.[] | select(.title == "discord") | .id')
discord_pwa=$(win_list | jq -c '.[] | select(.wm_class == "chrome-magkoliahgffibhgfkmoealggombgknl-Default") | .id')

win Activate "${discord[0]}"
sleep 0.1
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.1
ydotool key ${KEY_LEFTALT}:1 ${KEY_Z}:1 ${KEY_Z}:0 ${KEY_LEFTALT}:0
sleep 0.1
win Activate "${discord_pwa[0]}"
sleep 0.1
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.1
ydotool key ${KEY_LEFTALT}:1 ${KEY_X}:1 ${KEY_X}:0 ${KEY_LEFTALT}:0
sleep 1

./WB.sh &
sleep 3

wmctrl -s 16
kitty --title "Tutoring" --config "${SCRIPT_DIR}/kitty_tutoring.conf" &
firefox --private-window "https://theproductivedeveloper.com/" &

sleep 3

kitty=$(win_list | jq -c '.[] | select(.title == "Tutoring") | .id')
firefox=$(win_list | jq -c '.[] | select(.title == "Hyperspace by HTML5 UP — Mozilla Firefox Private Browsing") | .id')

win Activate "${kitty[0]}"
sleep 0.1
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.1
ydotool key ${KEY_LEFTALT}:1 ${KEY_Z}:1 ${KEY_Z}:0 ${KEY_LEFTALT}:0
sleep 0.1
win Activate "${firefox[0]}"
sleep 0.1
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.1
ydotool key ${KEY_LEFTALT}:1 ${KEY_X}:1 ${KEY_X}:0 ${KEY_LEFTALT}:0
sleep 1

wmctrl -s 2

bash -c "__NV_DISABLE_EXPLICIT_SYNC=1 flatpak run com.obsproject.Studio --verbose" &
sleep 6

# TODO limiter is spelled with a single T
pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK no effects:in_1"
pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK effects:in_1"
pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK no limiter:in_1"
# NOTE: This records all desktop audio output
# pw-link "alsa_output.usb-Focusrite_Scarlett_2i2_4th_Gen_S2JYTQ63508147-00.pro-output-0:monitor_AUX0" \
        # "OBS Studio: Student JCK:in_1"
pw-link "Discord_virtual_sink:monitor_FL" "OBS Studio: Student JCK:in_1"
pw-link "Discord_virtual_sink:monitor_FL" "OBS Studio: Student JCK no ducking:in_1"

# Set the default sink to the monitoring headphones & lower the volume so that
# there is no significant headphone bleed in the recording.
pactl set-default-sink alsa_output.usb-Focusrite_Scarlett_2i2_4th_Gen_S2JYTQ63508147-00.pro-output-0
# I also set the volume on my 2i2 to 50%, system volume is set to 50% just as a
# fail-safe. I can always increase the volume if it will be too quiet.
pactl set-sink-volume @DEFAULT_SINK@ 50%

obs-cmd fullscreen-projector
sleep 0.7

PROJECTOR_ID=$(win_list | jq '.[] | select(.wm_class == "com.obsproject.Studio") | select(.title == "Projector - Program") | .id')
win MoveToWorkspace "${PROJECTOR_ID}" 17

readonly SCENE1="1_my_whiteboard"
readonly SCENE2="2_student_screen"
readonly SCENE3="3_my_screen"

obs-cmd scene switch "${SCENE1}"

while true; do
    WORKSPACE=$(wmctrl -d | grep '\*' | awk '{print $1}')
    SCENE_STR=$(obs-cmd scene current)
    CURRENT_SCENE=${SCENE_STR##*Current scene: }

    if [[ "${WORKSPACE}" == "14" && "${CURRENT_SCENE}" != "${SCENE1}" ]]; then
        obs-cmd scene switch "${SCENE1}"
    elif [[ "${WORKSPACE}" == "15" && "${CURRENT_SCENE}" != "${SCENE2}" ]]; then
        obs-cmd scene switch "${SCENE2}"
    elif [[ "${WORKSPACE}" == "16" && "${CURRENT_SCENE}" != "${SCENE3}" ]]; then
        obs-cmd scene switch "${SCENE3}"
    fi

    if [[ "${WORKSPACE}" -lt "13" && "${CURRENT_SCENE}" == "ENTIRE_SCREEN" ]]; then
        # I have set up a keybinding to switch to this scene, but I want to
        # only allow it on workspace 13, so that I don't stream my private msgs
        # and stuff an by accident.
        pw-play ~/Music/Napalm_Death_You_Suffer.flac
        echo "$(date) OBS: Sharing entire screen on workspace ${WORKSPACE}" \
            >> ~/tmp/obs_screenshare.log
        obs-cmd scene switch "${SCENE1}"
    fi

    sleep 0.4
done
