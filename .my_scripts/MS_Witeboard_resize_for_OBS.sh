#!/bin/bash
set +x
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


# MoveResize takes 3 parameters: winid x y width height

win MoveResize "${MS_WHITEBOARD_IDS[0]}" 8 49 3277 2104
