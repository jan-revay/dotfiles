#!/bin/bash -x

# TODO consider using this trick everywhere
# resolve the directory where THIS script lives
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/window_calls_prelude.sh"


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

# TODO consider whether it makes sense to open todoist just to close it
todoist & # show Todoist window

for i in {1..35}; do
    WIN_LIST=$(win_list)

    FIREFOX_IDS=( $(ids_from_wm_class firefox_firefox) )
    TODOIST_IDS=( $(ids_from_wm_class Todoist) )
    MESSAGES_IDS=( $(ids_from_wm_class FFPWA-01K9Q465CXSRDW5E7JT05YB6F6) )
    MESSENGER_IDS=( $(ids_from_wm_class FFPWA-01K9Q3ZXJ98GTZQJ2V0TV72Z24) )
    WA_IDS=( $(ids_from_wm_class FFPWA-01K9Q307BN2CB01RVV704HZ3AD) )
    SIGNAL_IDS=( $(ids_from_wm_class org.signal.Signal) )
    NAUTILUS_IDS=( $(ids_from_wm_class org.gnome.Nautilus) )
    SPOTIFY_IDS=( $(ids_from_wm_class spotify) )
    GOOGLE_KEEP_IDS=( $(ids_from_wm_class FFPWA-01K9Q6Z5KPWRQX54K98TCARNCM) )
    GOOGLE_DRIVE_IDS=( $(ids_from_wm_class FFPWA-01K9VXM1XNH05FYVKZ47Q43PTJ) )
    GOOGLE_CAL_IDS=( $(ids_from_wm_class FFPWA-01K9VWZ3YQ3AR6QS81V8NJWXJ3) )
    GOOGLE_CAL_NEW_IDS=( $(ids_from_wm_class FFPWA-01K9VX1TWRMC3E4E48T7YX3AS6) )

    if (( ${#FIREFOX_IDS[@]} > 0 )) \
       && (( ${#TODOIST_IDS[@]} > 0 )) \
       && (( ${#MESSAGES_IDS[@]} > 0 )) \
       && (( ${#MESSENGER_IDS[@]} > 0 )) \
       && (( ${#WA_IDS[@]} > 0 )) \
       && (( ${#SIGNAL_IDS[@]} > 0 )) \
       && (( ${#NAUTILUS_IDS[@]} > 2 )) \
       && (( ${#GOOGLE_KEEP_IDS[@]} > 0 )) \
       && (( ${#SPOTIFY_IDS[@]} > 0 )) \
       && (( ${#GOOGLE_DRIVE_IDS[@]} > 2 )) \
       && (( ${#GOOGLE_CAL_IDS[@]} > 0 )) \
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


for id in "${FIREFOX_IDS[@]}"; do
    win MoveToWorkspace "$id" 0
done

win MoveToWorkspace "${NAUTILUS_IDS[0]}" 7
win MoveToWorkspace "${NAUTILUS_IDS[1]}" 7
win MoveToWorkspace "${NAUTILUS_IDS[2]}" 7
win Close "${TODOIST_IDS[0]}"
# TODO fix the window positions - now it might work correctly
# TODO - add note about the race conditions somewhere
# MoveResize takes 3 parameters: winid x y width height
win MoveResize "${SIGNAL_IDS[0]}" 1944 1125 1912 1051
win MoveResize "${WA_IDS[0]}" 24 1125 1912 1051
win MoveResize "${MESSENGER_IDS[0]}" 1950 68 1912 1052
win MoveResize "${MESSAGES_IDS[0]}" 24 65 1912 1052

# Tile windows on startup
# TODO make a function out of this and name & comment the code
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

ydotool mousemove --absolute -x 0 -y 0

win Activate "${SIGNAL_IDS[0]}"
sleep 0.1
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.05
ydotool key ${KEY_LEFTALT}:1 ${KEY_S}:1 ${KEY_S}:0 ${KEY_LEFTALT}:0
sleep 0.05
win Activate "${WA_IDS[0]}"
sleep 0.1
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.05
ydotool key ${KEY_LEFTALT}:1 ${KEY_A}:1 ${KEY_A}:0 ${KEY_LEFTALT}:0
sleep 0.05
win Activate "${MESSENGER_IDS[0]}"
sleep 0.1
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.05
ydotool key ${KEY_LEFTALT}:1 ${KEY_W}:1 ${KEY_W}:0 ${KEY_LEFTALT}:0
sleep 0.05
win Activate "${MESSAGES_IDS[0]}"
sleep 0.1
ydotool key ${KEY_LEFTMETA}:1 ${KEY_DOWN}:1 ${KEY_DOWN}:0 ${KEY_LEFTMETA}:0
sleep 0.05
ydotool key ${KEY_LEFTALT}:1 ${KEY_Q}:1 ${KEY_Q}:0 ${KEY_LEFTALT}:0
sleep 0.05

ydotool key ${KEY_LEFTALT}:1 ${KEY_8}:1 ${KEY_8}:0 ${KEY_LEFTALT}:0
sleep 0.05
ydotool key ${KEY_LEFTALT}:1 ${KEY_LEFTSHIFT}:1 ${KEY_Q}:1 \
    ${KEY_Q}:0 ${KEY_LEFTALT}:0 ${KEY_LEFTSHIFT}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05

ydotool key ${KEY_LEFTALT}:1 ${KEY_9}:1 ${KEY_9}:0 ${KEY_LEFTALT}:0
sleep 0.05
ydotool key ${KEY_LEFTALT}:1 ${KEY_LEFTSHIFT}:1 ${KEY_Q}:1 \
    ${KEY_Q}:0 ${KEY_LEFTALT}:0 ${KEY_LEFTSHIFT}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05

ydotool key ${KEY_LEFTALT}:1 ${KEY_0}:1 ${KEY_0}:0 ${KEY_LEFTALT}:0
sleep 0.05
win Activate "${GOOGLE_CAL_NEW_IDS[0]}"
sleep 0.05
ydotool key ${KEY_LEFTALT}:1 ${KEY_LEFTSHIFT}:1 ${KEY_Q}:1 \
    ${KEY_Q}:0 ${KEY_LEFTALT}:0 ${KEY_LEFTSHIFT}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0

ydotool key ${KEY_LEFTALT}:1 ${KEY_MINUS}:1 ${KEY_MINUS}:0 ${KEY_LEFTALT}:0
sleep 0.05
ydotool key ${KEY_LEFTALT}:1 ${KEY_LEFTSHIFT}:1 ${KEY_Q}:1 \
    ${KEY_Q}:0 ${KEY_LEFTALT}:0 ${KEY_LEFTSHIFT}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0

ydotool key ${KEY_LEFTALT}:1 ${KEY_EQUAL}:1 ${KEY_EQUAL}:0 ${KEY_LEFTALT}:0
sleep 0.05
win Activate "${GOOGLE_KEEP_IDS[0]}"
ydotool key ${KEY_LEFTALT}:1 ${KEY_LEFTSHIFT}:1 ${KEY_Q}:1 \
    ${KEY_Q}:0 ${KEY_LEFTALT}:0 ${KEY_LEFTSHIFT}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0

sleep 1
ydotool key ${KEY_LEFTALT}:1 ${KEY_1}:1 ${KEY_1}:0 ${KEY_LEFTALT}:0
sleep 0.15
ydotool key ${KEY_LEFTALT}:1 ${KEY_LEFTSHIFT}:1 ${KEY_Q}:1 \
    ${KEY_Q}:0 ${KEY_LEFTALT}:0 ${KEY_LEFTSHIFT}:0
sleep 0.15
# Send more KEY_ENTER events just in case there are more windows open
# on desktop 1
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
# for some reason, longer delay is needed here...
# otherwise the next shortcut does not work
sleep 0.25

sleep 2
ydotool key ${KEY_LEFTALT}:1 ${KEY_1}:1 ${KEY_1}:0 ${KEY_LEFTALT}:0
sleep 0.15
ydotool key ${KEY_LEFTALT}:1 ${KEY_LEFTSHIFT}:1 ${KEY_Q}:1 \
    ${KEY_Q}:0 ${KEY_LEFTALT}:0 ${KEY_LEFTSHIFT}:0
sleep 0.15
# Send more KEY_ENTER events just in case there are more windows open
# on desktop 1
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
sleep 0.05
ydotool key ${KEY_ENTER}:1 ${KEY_ENTER}:0
# for some reason, longer delay is needed here...
# otherwise the next shortcut does not work

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
