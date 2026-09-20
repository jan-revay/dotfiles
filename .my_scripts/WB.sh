#!/bin/bash
# starts and resizes MS Whiteboard for OBS
set +x

# resolve the directory where THIS script lives
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/window_calls_prelude.sh"

/snap/bin/chromium --profile-directory=Default --app-id=dnfpoenibinnbbckgbhendmlljoobcfg &
disown
# TODO consider using this trick everywhere
# resolve the directory where THIS script lives
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/window_calls_prelude.sh"

for i in {1..35}; do
  WIN_LIST=$(win_list)

  MS_WHITEBOARD_IDS=($(ids_from_wm_class chrome-dnfpoenibinnbbckgbhendmlljoobcfg-Default))
  if ((${#MS_WHITEBOARD_IDS[@]} > 0)); then
    break
  fi

  sleep 1
done

echo WindowID - captured: "${MS_WHITEBOARD_IDS[0]}"
# MoveResize takes 3 parameters: winid x y width height
sleep 0.55
win Maximize "${MS_WHITEBOARD_IDS[0]}"

# TODO - ohranicenie plochy kt. je aktivna v OBSku via kitty
