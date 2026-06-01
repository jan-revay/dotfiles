#!/bin/bash -x

bash -c "__NV_DISABLE_EXPLICIT_SYNC=1 flatpak run com.obsproject.Studio --verbose" &
sleep 7

# TODO limiter is spelled with a single T
pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK no effects:in_1"
pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK effects:in_1"
pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK no limiter:in_1"

# TODO also try to connect student audio automatically

obs-cmd fullscreen-projector

# resolve the directory where THIS script lives
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/window_calls_prelude.sh"

PROJECTOR_ID=$(win_list | jq '.[] | select(.wm_class == "com.obsproject.Studio") | select(.title == "Projector - Program") | .id')
win MoveToWorkspace "${PROJECTOR_ID}" 16

readonly SCENE1="1_my_whiteboard"
readonly SCENE2="2_student_screen"
readonly SCENE3="3_my_screen"

while true; do
    WORKSPACE=$(wmctrl -d | grep '\*' | awk '{print $1}')
    SCENE_STR=$(obs-cmd scene current)
    CURRENT_SCENE=${SCENE_STR##*Current scene: }

    if [[ "${WORKSPACE}" == "13" && "${CURRENT_SCENE}" != "${SCENE1}" ]]; then
        obs-cmd scene switch "${SCENE1}"
    elif [[ "${WORKSPACE}" == "14" && "${CURRENT_SCENE}" != "${SCENE2}" ]]; then
        obs-cmd scene switch "${SCENE2}"
    elif [[ "${WORKSPACE}" == "15" && "${CURRENT_SCENE}" != "${SCENE3}" ]]; then
        obs-cmd scene switch "${SCENE3}"
    fi

    sleep 0.5
done
