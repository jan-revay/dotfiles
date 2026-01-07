#!/bin/bash

ffmpeg -i "$1" -c:v copy -c:a libopus -b:a 256k -ac 1 "$1_mono.mkv"
