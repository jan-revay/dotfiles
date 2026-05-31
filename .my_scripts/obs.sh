#!/bin/bash -x

bash -c "__NV_DISABLE_EXPLICIT_SYNC=1 flatpak run com.obsproject.Studio --verbose" &
sleep 7

pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK no effects:in_1"
pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK effects:in_1"
pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK no limitter:in_1"

# TODO also try to connect student audio automatically


readonly SCENE1="1_my_whiteboard"
readonly SCENE2="2_student_screen"
readonly SCENE3="3_my_screen"

while true; do
    WORKSPACE=$(wmctrl -d | grep '\*' | awk '{print $1}')
    SCENE_STR=$(obs-cmd scene current)
    CURRENT_SCENE=${SCENE_STR##*Current scene: }

    if [[ "${WORKSPACE}" == "13" && "${CURRENT_SCENE}" != "${SCENE1}" ]]; then
        obs-cmd scene switch "$SCENE1"
    elif [[ "${WORKSPACE}" == "14" && "${CURRENT_SCENE}" != "${SCENE2}" ]]; then
        obs-cmd scene switch "$SCENE2"
    elif [[ "${WORKSPACE}" == "15" && "${CURRENT_SCENE}" != "${SCENE3}" ]]; then
        obs-cmd scene switch "$SCENE3"
    fi

    sleep 1
done
