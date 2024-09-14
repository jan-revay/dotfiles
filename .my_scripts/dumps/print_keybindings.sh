#!/bin/bash -x

echo "==== START - List of all keybindings ===="
gsettings list-recursively | grep -i -E 'media-keys|keybindings'
echo "==== END - List of all keybindings ===="
