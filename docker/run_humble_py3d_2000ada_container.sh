#!/bin/bash

# Get the full path to itself
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Running container
docker run -it --privileged --rm \
               --name humble_py3d_2000ada \
               --net=host \
               --gpus all \
               -e DISPLAY=$DISPLAY \
               -v /tmp/.X11-unix:/tmp/.X11-unix \
               -v $XAUTHORITY:/dot.Xauthority \
               -v $SCRIPT_DIR/../../units_ws:/home/code \
               -w /home/code \
               humble_py3d_2000ada bash
