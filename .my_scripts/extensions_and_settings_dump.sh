#!/bin/bash -x

echo "===== All extensions ====="
gnome-extensions list

echo
echo "===== Enabled extensions ======"
gnome-extensions list --enabled

echo
echo "===== Disabled extensions ======"
gnome-extensions list --disabled


echo "===== All extensions with details ====="
gnome-extensions list -d

echo
echo "===== Enabled extensions with details ======"
gnome-extensions list --enabled -d

echo
echo "===== GNOME dconf dump ======"
dconf dump /org/gnome/
