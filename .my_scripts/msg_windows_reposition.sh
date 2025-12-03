#!/bin/bash -x
. ../initPC/prelude.sh

# Use
#     gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows --method org.gnome.Shell.Extensions.Windows.List | rg -o "\[[^\]]+\]"     | jq .

# TODO try to cause a race condition by setting a windows in focus and reading the
# focus state so that I can see whether I need to add spinlocks to
# to list the windows
# TODO usde for_each macro and rewrite it so that it works here
# TODO - condifer whether I need to add the sleep commands or not


# TODO try using activate and keybindings (alt qwaszx) to tile the windows
# in a way that WM registers as tiles
# TODO - what if there is more than one instance of the window?
# TODO - ChatGPT and Claude code review

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
    win List | rg -o "\[[^\]]+\]"
}

win_list_formatted() {
    win_list | jq .
}

ids_from_wm_class() {
    jq -c --arg class "$1" '.[] | select(.wm_class == $class) | .id' <<< "${WIN_LIST}"
}


for i in {1..35}; do
    WIN_LIST=$(win_list)

    MESSAGES_IDS=( $(ids_from_wm_class FFPWA-01K9Q465CXSRDW5E7JT05YB6F6) )
    MESSENGER_IDS=( $(ids_from_wm_class FFPWA-01K9Q3ZXJ98GTZQJ2V0TV72Z24) )
    WA_IDS=( $(ids_from_wm_class FFPWA-01K9Q307BN2CB01RVV704HZ3AD) )
    SIGNAL_IDS=( $(ids_from_wm_class org.signal.Signal) )

    if (( ${#MESSAGES_IDS[@]} > 0 )) \
       && (( ${#MESSENGER_IDS[@]} > 0 )) \
       && (( ${#WA_IDS[@]} > 0 )) \
       && (( ${#SIGNAL_IDS[@]} > 0 )); then
        break
    fi
    
    sleep 1
done

# NOTE: for some reason position need to be added to a offset (20,20)
# TODO isn't that just sync issue? Does sleep fix that?
# TODO for_each "sleep 0.1; gdbus...." <<
# TODO alternatively I can declare a variable with the prefix and use that
# that would be probably more suitable given the mixing of gdbus and Window Calls
# I can name the variable $W co that it is easy to access I would need to use it as "$W"
# because of the spaces?
# W="sleep 0.05
# gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
#     --method org.gnome.Shell.Extensions.Windows"
# TODO every window calls call could theoretically wait untill the change propagated to gnome
# i.s. read the window info and spinlock untill the change is not registered

win MoveToWorkspace "${MESSAGES_IDS[0]}" 3
win MoveToWorkspace "${MESSENGER_IDS[0]}" 3
win MoveToWorkspace "${WA_IDS[0]}" 3
win MoveToWorkspace "${SIGNAL_IDS[0]}" 3

ydotool mousemove --absolute -x 0 -y 0

# TODO make this grep&sed more robust so that it is able to parse any or almost
# any C code (also with // comments, with comments in between etc.)
grep '^#define[[:space:]]\+KEY_' /usr/include/linux/input-event-codes.h \
    | sed -E 's/^#define[[:space:]]+([A-Za-z0-9_]+)[[:space:]]+(.+)$/\1=\2/' \
    | sed 's/\/\*/#/' \
    | sed 's/\*\///' \
    > /tmp/ydotool_keycodes.sh
source /tmp/ydotool_keycodes.sh

win Activate "${SIGNAL_IDS[0]}"
sleep 0.15
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.15
ydotool key ${KEY_LEFTALT}:1 ${KEY_S}:1 ${KEY_S}:0 ${KEY_LEFTALT}:0
sleep 0.15
win Activate "${WA_IDS[0]}"
sleep 0.15
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.15
ydotool key ${KEY_LEFTALT}:1 ${KEY_A}:1 ${KEY_A}:0 ${KEY_LEFTALT}:0
sleep 0.15
win Activate "${MESSENGER_IDS[0]}"
sleep 0.15
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.15
ydotool key ${KEY_LEFTALT}:1 ${KEY_W}:1 ${KEY_W}:0 ${KEY_LEFTALT}:0
sleep 0.15
win Activate "${MESSAGES_IDS[0]}"
sleep 0.15
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.15
ydotool key ${KEY_LEFTALT}:1 ${KEY_Q}:1 ${KEY_Q}:0 ${KEY_LEFTALT}:0
sleep 0.15
