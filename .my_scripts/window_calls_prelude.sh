#!/bin/bash

# TODO make a function out of this and name & comment the code
# TODO consider moving this somewhere else
# Left Alt	56	KEY_LEFTALT
# Left Shift	42	KEY_LEFTSHIFT
# 1	2	KEY_1
# 2	3	KEY_2
# Q	16	KEY_Q
# Enter	28	KEY_ENTER
# https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
# TODO make this grep&sed more robust so that it is able to parse any or almost
# any C code (also with // comments, with comments in between etc.)
grep '^#define[[:space:]]\+KEY_' /usr/include/linux/input-event-codes.h \
    | sed -E 's/^#define[[:space:]]+([A-Za-z0-9_]+)[[:space:]]+(.+)$/\1=\2/' \
    | sed 's/\/\*/#/' \
    | sed 's/\*\///' \
    > /tmp/ydotool_keycodes.sh
source /tmp/ydotool_keycodes.sh

# TODO move completely to dbus-send
win() {
    local method="$1"
    shift
    gdbus call --session \
        --dest org.gnome.Shell \
        --object-path /org/gnome/Shell/Extensions/Windows \
        --method org.gnome.Shell.Extensions.Windows."$method" \
        "$@"
}

win_list() {
    dbus-send --session --print-reply=literal \
                        --dest=org.gnome.Shell \
                        /org/gnome/Shell/Extensions/Windows \
                        org.gnome.Shell.Extensions.Windows.List
}

win_list_formatted() {
    win_list | jq .
}

ids_from_wm_class() {
    jq -c --arg class "$1" '.[] | select(.wm_class == $class) | .id' <<< "${WIN_LIST}"
}

id_of_focused() {
    jq -c '.[] | select(.focus) | .id' <<< "${WIN_LIST}"
}


focused_workspace() {
    jq -c '.[] | select(.focus) | .workspace' <<< "${WIN_LIST}"
}

win_details_from_id() {
    dbus-send --session --print-reply=literal \
                        --dest=org.gnome.Shell \
                        /org/gnome/Shell/Extensions/Windows \
                        org.gnome.Shell.Extensions.Windows.Details uint32:$1
}
