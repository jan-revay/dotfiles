#!/bin/bash -x

# resolve the directory where THIS script lives
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/window_calls_prelude.sh"

WIN_LIST=$(win_list)
FOCUSED=$(id_of_focused)

win MoveToWorkspace "$FOCUSED" "$1"
win Activate "$FOCUSED"
