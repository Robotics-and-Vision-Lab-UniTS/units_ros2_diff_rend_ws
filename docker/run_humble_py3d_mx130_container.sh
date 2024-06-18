#!/bin/bash

# Get the full path to itself
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Giving permession to forward GUIs streams
xhost +

# Running container
docker run -it --privileged --rm \
               --name humble_py3d_mx130 \
               --net=host \
               --gpus all \
               -e DISPLAY=$DISPLAY \
               -v /tmp/.X11-unix:/tmp/.X11-unix \
               -v $SCRIPT_DIR/../../../../units_ws:/home/code \
               -w /home/code \
               humble_py3d_mx130 bash
