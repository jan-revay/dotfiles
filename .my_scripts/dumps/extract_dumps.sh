#!/bin/bash -x

read -r -s -p "Password: " PW
 
pushd backup_config_dumps

find . -type f -name "*.log.encrypted" -execdir 7z x -p"${PW}" {} \;

popd
