#!/bin/bash
set -e

ros_env_setup="/opt/ros/$ROS_DISTRO/setup.bash"
catkin_env_setup="/home/code/install/local_setup.bash"
echo "sourcing   $ros_env_setup"
source "$ros_env_setup"

echo "sourcing   $catkin_env_setup"
source "$catkin_env_setup"

echo "ROS_DISTRO $ROS_DISTRO"

exec "$@"