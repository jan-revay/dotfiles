#!/bin/bash

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
    # Extract only the JSON argument returned by GDBus
    win List | sed 's/^(.//; s/.,)$//'
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

win_details_from_id() {
   win Details $1 | sed "s/^('//; s/',)$//" | jq .
}
