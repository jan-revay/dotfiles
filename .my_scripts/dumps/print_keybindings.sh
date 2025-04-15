#!/bin/bash -x

# TODO - this is quite incomplete, try searching for modifier keys also
# e.g. <meta><ctrl>...

echo "==== START - List of all keybindings ===="
gsettings list-recursively | grep -i -E 'media-keys|keybindings'
dconf dump / | grep -i -E 'media-keys|keybinding|shortcut'
echo "==== END - List of all keybindings ===="
