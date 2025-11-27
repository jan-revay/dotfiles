#!/bin/bash -x
. ../initPC/prelude.sh

# Use
#     gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows --method org.gnome.Shell.Extensions.Windows.List | rg -o "\[[^\]]+\]"     | jq .

# to list the windows
# TODO usde for_each macro and rewrite it so that it works here


# TODO try using activate and keybindings (alt qwaszx) to tile the windows
# in a way that WM registers as tiles
# TODO - what if there is more than one instance of the window?

ids_from_wm_class() {
    gdbus call --session --dest org.gnome.Shell \
    --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.List \
    | rg -o "\[[^\]]+\]" \
    | jq -c ".[] | select (.wm_class == \"$1\") | .id"
}


for i in {1..15}; do
    FIREFOX_IDS=( $(ids_from_wm_class firefox_firefox) )
    TODOIST_IDS=( $(ids_from_wm_class Todoist) )
    MESSAGES_IDS=( $(ids_from_wm_class FFPWA-01K9Q465CXSRDW5E7JT05YB6F6) )
    MESSENGER_IDS=( $(ids_from_wm_class FFPWA-01K9Q3ZXJ98GTZQJ2V0TV72Z24) )
    WA_IDS=( $(ids_from_wm_class FFPWA-01K9Q307BN2CB01RVV704HZ3AD) )
    SIGNAL_IDS=( $(ids_from_wm_class org.signal.Signal) )
    NAUTILUS_IDS=( $(ids_from_wm_class org.gnome.Nautilus) )
    GOOGLE_CAL_NEW_IDS=( $(ids_from_wm_class FFPWA-01K9VX1TWRMC3E4E48T7YX3AS6) )

    if (( ${#FIREFOX_IDS[@]} > 0 )) \
       && (( ${#TODOIST_IDS[@]} > 0 )) \
       && (( ${#MESSAGES_IDS[@]} > 0 )) \
       && (( ${#MESSENGER_IDS[@]} > 0 )) \
       && (( ${#WA_IDS[@]} > 0 )) \
       && (( ${#SIGNAL_IDS[@]} > 0 )) \
       && (( ${#NAUTILUS_IDS[@]} > 2 )) \
       && (( ${#GOOGLE_CAL_NEW_IDS[@]} > 0 )); then
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

gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.MoveToWorkspace "${FIREFOX_IDS[0]}" 0
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.MoveToWorkspace "${NAUTILUS_IDS[0]}" 2
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.MoveToWorkspace "${NAUTILUS_IDS[1]}" 2
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.MoveToWorkspace "${NAUTILUS_IDS[2]}" 2

gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Close "${TODOIST_IDS[0]}"

gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Move "${SIGNAL_IDS[0]}" 1944 1125
sleep 0.1
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Resize "${SIGNAL_IDS[0]}" 1912 1051
sleep 0.1
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Activate "${SIGNAL_IDS[0]}"
sleep 0.1

gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Move "${WA_IDS[0]}" 24 1125
sleep 0.1
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Resize "${WA_IDS[0]}" 1912 1051
sleep 0.1
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Activate "${WA_IDS[0]}"
sleep 0.1

gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Move "${MESSENGER_IDS[0]}" 1950 68
sleep 0.1
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Resize "${MESSENGER_IDS[0]}" 1912 1052
sleep 0.1
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Activate "${MESSENGER_IDS[0]}"
sleep 0.1

gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Move "${MESSAGES_IDS[0]}" 24 65
sleep 0.1
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Resize "${MESSAGES_IDS[0]}" 1912 1052
sleep 0.1
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Activate "${MESSAGES_IDS[0]}"


# TODO - wait until the windows are open and remove the sleep
sleep 5

# Tile windows on startup
# TODO make a function out of this and name & comment the code
# Left Alt	56	KEY_LEFTALT
# Left Shift	42	KEY_LEFTSHIFT
# 1	2	KEY_1
# 2	3	KEY_2
# Q	16	KEY_Q
# Enter	28	KEY_ENTER
# https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
ydotool key 56:1 42:1 31:1 56:0 42:0 31:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05
ydotool key 28:1 28:0

ydotool key 56:1 2:1 2:0 56:0
sleep 0.05
ydotool key 56:1 42:1 16:1 16:0 42:0 56:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05

ydotool key 56:1 4:1 4:0 56:0
sleep 0.05
ydotool key 56:1 42:1 16:1 16:0 42:0 56:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05
ydotool key 28:1 28:0

ydotool key 56:1 9:1 9:0 56:0
sleep 0.05
ydotool key 56:1 42:1 16:1 16:0 42:0 56:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05
ydotool key 28:1 28:0

ydotool key 56:1 10:1 10:0 56:0
sleep 0.05
ydotool key 56:1 42:1 16:1 16:0 42:0 56:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05

ydotool key 56:1 11:1 11:0 56:0
sleep 0.05
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows \
    --method org.gnome.Shell.Extensions.Windows.Activate "${GOOGLE_CAL_NEW_IDS[0]}"
sleep 0.05
ydotool key 56:1 42:1 16:1 16:0 42:0 56:0
sleep 0.05
ydotool key 28:1 28:0
sleep 0.05
ydotool key 28:1 28:0

# TODO: rewrite using list of windows, map and for_each function
# napady na faktorizaciu
# 1. napisat to v pythone? - netreba
# 2. fcia getIdFromClass
# 3. fcia get ids (caka v cykle kym vsetky idcka bidi existovat) - vracoa map - nazov triedy -> id
# 4. samotne cally co roboa s oknami veci
#
# # TOREAD https://en.wikipedia.org/wiki/D-Bus
#
# windows=(a b c)
#
# getWindowIdFromClass(){ # array parameter and map return value, so that I don't need to call DBus multiple times
#     # dbus call
#     # returns map with map[loaded] = false so that I can easily check that all ids were found (that one key is enough)
# }
#
# waitForIds(){
#     WOMDOWS=$1
#     declare -A IDS
#
#     for i in {1..30}; do
#         for win in $WINDOWS; do
#             id=getWondowIdFromClass $wim
#
#             if [[ $id == "" ]]; then
#                 sleep 1
#                 break
#             fi
#
#             IDS[$win]=$is
#         done
#     done
#
#     return $IDS
# }
#
# TODO maybe use not "BASH" but BASH - find out differences between quoted and unquoted delimiter
# for_each "gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/Windows --method org.gnome.Shell.Extensions.Windows." <<"BASH"
#   MoveToWorkspace "${IDS["Firefox"]}" 0
#   Close "${IDS["Todoist"]}"
# BASH






# TODO Wayland support
# TODO improve - try sth. that is not dependent on timing so much
# TODO remove dependence on the put window GNOME extension
# TODO try writing my own GNOME extension for this stuff
# TODO ?try to solve this via virtual desktop-specific tiling?

# sleep 120

# use `$ xprop` to find out the properties of the window (e.g. class)
#
# eval "$(xdotool search --onlyvisible --desktop 3 --shell --class org.gnome.Nautilus)"
# xdotool windowsize "${WINDOWS[1]}" 50% 40%
# xdotool windowsize "${WINDOWS[0]}" 50% 40%
#
# xdotool windowmove "${WINDOWS[0]}" 0% 60%
# xdotool windowmove "${WINDOWS[1]}" 50% 60%
#
# eval "$(xdotool search --onlyvisible --shell --name "Google Chrome")"
# xdotool set_desktop_for_window "${WINDOWS[0]}" 0
# xdotool windowmove "${WINDOWS[0]}" 0% 16%
# xdotool windowsize "${WINDOWS[0]}" 102% 86%
#
# eval "$(xdotool search --onlyvisible --shell --name "Mozilla Firefox")"
# xdotool set_desktop_for_window "${WINDOWS[0]}" 2
# xdotool windowmove "${WINDOWS[0]}" 0% 16%
# xdotool windowsize "${WINDOWS[0]}" 102% 86%
#
# eval "$(xdotool search --onlyvisible --shell --name "Todoist")"
# xdotool set_desktop_for_window "${WINDOWS[0]}" 1
# xdotool windowmove "${WINDOWS[0]}" 0% 0%
# xdotool windowsize "${WINDOWS[0]}" 80% 45%
#
# eval "$(xdotool search --onlyvisible --shell --name "Google Keep")"
# xdotool set_desktop_for_window "${WINDOWS[0]}" 2
#
# eval "$(xdotool search --onlyvisible --shell --name "Caprine")"
# xdotool set_desktop_for_window "${WINDOWS[0]}" 4
#
# eval "$(xdotool search --onlyvisible --shell --name "Signal")"
# xdotool set_desktop_for_window "${WINDOWS[0]}" 4
