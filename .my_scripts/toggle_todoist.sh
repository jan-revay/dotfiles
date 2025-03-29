FOCUS="$(gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows --method org.gnome.Shell.Extensions.Windows.List | head -c -4 | tail -c +3 | jq -c '[.[] | select (.focus == true) | {wm_class: .wm_class}]')"

if [[ "${FOCUS}" == '[{"wm_class":"Todoist"}]' ]]; then
    exit 0
fi

todoist
