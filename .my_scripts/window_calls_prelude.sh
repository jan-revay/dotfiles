#!/bin/bash

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
