#!/bin/bash -x



pushd backup_config_dumps

find . -type f -name "*.log.encrypted" -execdir 7z x {} \;

popd
