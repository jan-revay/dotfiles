#!/bin/bash -x

# TODO - create a cron job for this...
# resp. maybe just use cron weekly folder resp. anacron or sth like that
# so that it is not power-on time dependent

readonly GNOME_DUMP_FILENAME="GNOME_extensions_and_settings_dump_$(date '+%Y%m%d_%H%M%S').log"
# TODO
#readonly DCONF_DUMP_FILENAME=

pushd backup_config_dumps
../GNOME_extensions_and_settings_dump.sh &>> "${GNOME_DUMP_FILENAME}"
../print_keybindings.sh &>> "${GNOME_DUMP_FILENAME}"
dconf dump / &>> "${GNOME_DUMP_FILENAME}"
../chromium_extensions.sh &>> "${GNOME_DUMP_FILENAME}"
echo "--- BASH HISTORY ---" &>> "${GNOME_DUMP_FILENAME}"
cat "$HOME/.bash_history" &>> "${GNOME_DUMP_FILENAME}"

# TODO review (and improve) - encrypt the dumps, just in case
7z a -p -mx=9 -mhe=on "${GNOME_DUMP_FILENAME}.encrypted" "${GNOME_DUMP_FILENAME}"
rm "${GNOME_DUMP_FILENAME}"
rm *.log


popd
