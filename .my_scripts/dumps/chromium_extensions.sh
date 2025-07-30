#!/bin/bash

echo === Chromium extensions ===

jq '.extensions.settings | to_entries[] | {id: .key, name: .value.manifest.name, version: .value.manifest.version}'  \
    ~/snap/chromium/common/chromium/Profile\ 2/Preferences

echo === END Chromium extensions
