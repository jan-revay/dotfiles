#!/bin/bash

SCENE_STR=$(obs-cmd scene current)
CURRENT_SCENE=${SCENE_STR##*Current scene: }

echo "${CURRENT_SCENE}"
