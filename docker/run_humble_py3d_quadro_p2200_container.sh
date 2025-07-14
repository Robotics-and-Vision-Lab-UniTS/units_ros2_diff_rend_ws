#!/bin/bash

# Get the full path to itself
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Running container
docker run -it --privileged --rm \
               --name humble_py3d_quadro_p2200 \
               --net=host \
               --gpus all \
               -e DISPLAY=$DISPLAY \
               -e QT_X11_NO_MITSHM=1 \
               -v /tmp/.X11-unix:/tmp/.X11-unix \
               -v $HOME/.Xauthority:/root/.Xauthority:rw \
               -v $SCRIPT_DIR/../../units_ws:/home/code \
               -v /dev/snd:/dev/snd:ro \
               -w /home/code \
               humble_py3d_quadro_p2200 bash
