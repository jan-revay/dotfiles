#!/bin/bash
# starts and resizes MS Whiteboard for OBS
set +x
/snap/bin/chromium --profile-directory=Default --app-id=fjjhhjjhgaipgagmgnjalbkgadhniebn & disown
# TODO consider using this trick everywhere
# resolve the directory where THIS script lives
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/window_calls_prelude.sh"

for i in {1..35}; do
    WIN_LIST=$(win_list)

    MS_WHITEBOARD_IDS=( $(ids_from_wm_class chrome-fjjhhjjhgaipgagmgnjalbkgadhniebn-Default) )
    if (( ${#MS_WHITEBOARD_IDS[@]} > 0 )); then
        break
    fi
    
    sleep 1
done

echo WindowID: "${MS_WHITEBOARD_IDS[0]}"
# MoveResize takes 3 parameters: winid x y width height
win Unmaximize "${MS_WHITEBOARD_IDS[0]}"
sleep 0.05
win MoveResize "${MS_WHITEBOARD_IDS[0]}" 8 49 3282 2104
