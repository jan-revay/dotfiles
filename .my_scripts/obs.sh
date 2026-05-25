#!/bin/bash

bash -c "__NV_DISABLE_EXPLICIT_SYNC=1 flatpak run com.obsproject.Studio" &
sleep 15

pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK no effects:in_1"
pw-link "My 2i2_MONO:capture_MONO" "OBS Studio: sm7 JCK effects:in_1"

# TODO also try to connect student audio automatically
