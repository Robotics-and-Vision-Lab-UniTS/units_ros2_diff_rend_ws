#!/bin/bash
xhost +local:root

# Get the full path to itself
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Running container
docker run -it --privileged --rm \
               --name humble_py3d_2000ada_isaac \
               --net=host \
               --gpus all \
               -e DISPLAY=$DISPLAY \
               -e OMNI_ACCEPT_EULA=YES \
               -e OMNI_ENV_PRIVACY_CONSENT=YES \
               -e OMNI_KIT_ALLOW_ROOT=1 \
               -e XDG_RUNTIME_DIR=/run/user/$(id -u) \
               -v /tmp/.X11-unix:/tmp/.X11-unix \
               -v $XAUTHORITY:/root/.Xauthority \
               -v $SCRIPT_DIR/../../units_ros2_diff_rend_ws:/home/code \
               -w /home/code \
               --entrypoint /bin/bash \
               humble_py3d_2000ada_isaac
