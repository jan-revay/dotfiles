#!/bin/bash -x

readonly GNOME_DUMP_FILENAME="GNOME_extensions_and_settings_dump_$(date '+%Y%m%d_%H%M%S').log"
# TODO
#readonly DCONF_DUMP_FILENAME=

pushd backup_config_dumps
../GNOME_extensions_and_settings_dump.sh &> "${GNOME_DUMP_FILENAME}"
../print_keybindings.sh &> "${GNOME_DUMP_FILENAME}"

# TODO review (and improve) - encrypt the dumps, just in case
7z a -p -mx=9 -mhe=on "${GNOME_DUMP_FILENAME}.encrypted" "${GNOME_DUMP_FILENAME}"
rm "${GNOME_DUMP_FILENAME}"


popd
