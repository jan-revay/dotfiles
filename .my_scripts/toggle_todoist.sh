#!/bin/bash -x

FOCUS="$(gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows --method org.gnome.Shell.Extensions.Windows.List | head -c -4 | tail -c +3 | jq -c '[.[] | select (.focus == true) | {id: .id,wm_class: .wm_class}]')"
ID_JSON="$(gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows --method org.gnome.Shell.Extensions.Windows.List | head -c -4 | tail -c +3 | jq -c '[.[] | select (.wm_class == "Todoist") | {id: .id}]')"
ID=$(grep -oP '[0-9]+' <<< "${ID_JSON}")

if [[ "${FOCUS}" =~ '"wm_class":"Todoist"' ]]; then
    gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows --method org.gnome.Shell.Extensions.Windows.Minimize "${ID}"
else
#     gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows --method org.gnome.Shell.Extensions.Windows.Unminimize "${ID}"
todoist
fi
