#!/bin/bash -x

./GNOME_extensions_and_settings_dump.sh &> \
    ~/.backup_config_dumps/GNOME_extensions_and_settings_dump_$(date '+%Y%m%d_%H%M%S').log
