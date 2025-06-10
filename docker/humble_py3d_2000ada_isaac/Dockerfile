FROM nvcr.io/nvidia/isaac-sim:4.5.0

ENV DEBIAN_FRONTEND noninteractive

RUN  apt-get update && apt upgrade -y \
  && apt-get install -y \
  build-essential \
  curl \
  wget \
  libgl1-mesa-glx \
  libglib2.0-0 \
  libsm6 \
  libxext6 \
  libxrender-dev \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --allow-downgrades libbrotli1=1.0.9-2build6

# Install ros2 humble
RUN apt -y -qq update && apt -y -qq install software-properties-common mesa-utils libglu1-mesa-dev\
  freeglut3-dev mesa-common-dev libglew-dev libglfw3-dev libglm-dev \
  libao-dev libmpg123-dev libasio-dev && \
  add-apt-repository universe && \
  apt -y -qq update && apt install curl -y && \
  curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
  apt -y -qq update && \
  apt -y -qq upgrade && \
  apt -y -qq install ros-humble-desktop \
    ros-humble-ament-cmake ros-humble-angles ros-humble-controller-manager \
    ros-humble-pluginlib ros-humble-urdf ros-humble-yaml-cpp-vendor ros-humble-joint-state-pub* \
    ros-humble-cv-bridge ros-humble-diagnostic-updater \
    ros-humble-moveit && \
  apt-get install -y -qq ros-humble-xacro ros-humble-realtime-tools ros-humble-control-toolbox ros-humble-ros2-control* ros-humble-ros-testing \
    ros-humble-teleop-twist-keyboard ros-humble-vision-msgs && \
  : "remove cache" && \
  apt-get autoremove -y -qq && \
  rm -rf /var/lib/apt/lists/*
  
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    lsb-release \
    python3-colcon-ros \
    telnet \
    && apt-get clean

# Install ROS2 bridge for Isaac Sim
RUN apt-get update && apt-get install -y \
    ros-humble-ros-ign-bridge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV ACCEPT_EULA=Y
ENV PRIVACY_CONSENT=Y
# ENV LANG=en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8
ENV ROS_DISTRO=humble
ENV ROS_VERSION=2
ENV ROS_PYTHON_VERSION=3

# # Set up volumes for caches and data
# # VOLUME ["/isaac-sim/kit/cache", "/root/.cache/ov", "/root/.cache/pip", "/root/.cache/nvidia/GLCache", "/root/.nv/ComputeCache", "/root/.nvidia-omniverse/logs", "/root/.local/share/ov/data", "/root/Documents"]


RUN pip install trimesh imageio imageio-ffmpeg
ENV CUDA_HOME="/usr/local/cuda-12.4"
ENV FORCE_CUDA=1
ENV PATH="$CUDA_HOME/bin:$PATH"
ENV LD_LIBRARY_PATH="${CUDA_HOME}/lib64$LD_LIBRARY_PATH"
# Set GPU architecture required to compile torch related libraries https://en.wikipedia.org/wiki/CUDA
ENV TORCH_CUDA_ARCH_LIST="8.9"
RUN pip install torch==2.3.1 torchvision==0.18.1
RUN pip install -U fvcore
RUN pip install -U iopath

# Installing NVIDIA toolkit compatible with GPU driver and CUDA that you have installed on your pc
RUN wget https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda_12.4.0_550.54.14_linux.run

RUN sh cuda_12.4.0_550.54.14_linux.run --silent --toolkit
# RUN ln -s /usr/bin/gcc-10 /usr/local/cuda-12.4/bin/gcc
RUN  apt-get update \
  && apt-get install -y \
  git \
  && rm -rf /var/lib/apt/lists/*

RUN pip install 'git+https://github.com/facebookresearch/pytorch3d.git@stable'




RUN  apt-get update \
  && apt-get install -y ros-humble-joint-state-publisher-gui \
  ros-humble-ros2-control ros-humble-ros2-controllers ros-humble-gazebo-ros2-control ros-humble-gazebo-plugins \ 
  libnlopt-dev libnlopt-cxx-dev \
  && rm -rf /var/lib/apt/lists/*


RUN pip install opencv-python
RUN pip install pyrender numpy-stl tikzplotlib numpy-quaternion

# # Installation of SW for OAK D-POE
RUN  apt-get update && \
apt-get install -y iputils-ping ros-humble-depthai-ros\
&& rm -rf /var/lib/apt/lists/*
RUN pip install depthai


# Installation of Xauthority to allow gui visualization through docker using laptop's key
RUN  apt-get update && apt upgrade -y \
     && apt-get install -y xauth unzip \
     && rm -rf /var/lib/apt/lists/*

# RUN echo 'xauth merge /root/.Xauthority' >> /root/.bashrc

# # Create a non-root user
# ARG USERNAME=ros
# ARG USER_UID=1001
# ARG USER_GID=$USER_UID

# RUN groupadd --gid $USER_GID $USERNAME \
#   && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
#   && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654

# # Set up sudo
RUN apt-get update \
  && apt-get install -y sudo \
#   && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
#   && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

RUN  apt-get update && apt upgrade -y \
     && apt-get install -y ros-humble-ign-ros2-control \
     && rm -rf /var/lib/apt/lists/*

# Install zed software

RUN  apt-get update && apt upgrade -y \
     && apt-get install -y \
     zstd \
     usbutils \
     udev \
     && rm -rf /var/lib/apt/lists/*

RUN echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"' | sudo tee /etc/udev/rules.d/80-movidius.rules

ENV PYTHONPATH="$PYTHONPATH:/home/code/src/common_utils"

RUN pip install kornia 
RUN pip uninstall numpy -y

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    python3-pcl \
    pcl-tools \
    && rm -rf /var/lib/apt/lists/*


RUN pip install numpy==1.26.4
RUN pip install open3d

# Install debugging packages
RUN  apt-get update && apt upgrade -y \
     && apt-get install -y \
     gdb \
     gdbserver \
     && rm -rf /var/lib/apt/lists/*


# Install Isaac sim

RUN wget -qO - https://isaac.download.nvidia.com/isaac-ros/repos.key | sudo apt-key add -
RUN grep -qxF "deb https://isaac.download.nvidia.com/isaac-ros/release-3 $(lsb_release -cs) release-3.0" /etc/apt/sources.list || \
RUN echo "deb https://isaac.download.nvidia.com/isaac-ros/release-3 $(lsb_release -cs) release-3.0" | sudo tee -a /etc/apt/sources.list
RUN sudo apt-get update && rm -rf /var/lib/apt/lists/*



# Installing Ros middleware protocol zenoh
RUN apt-get update \
    && sudo apt-get install -y \
    ros-$ROS_DISTRO-rmw-zenoh-cpp \
    ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
    ros-$ROS_DISTRO-vision-msgs \
    ros-$ROS_DISTRO-topic-based-ros2-control \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# # Vulkan
# RUN apt-get update \
#     && sudo apt-get install -y \
#     vulkan-tools \
#     && rm -rf /var/lib/apt/lists/*

ENV AMENT_PREFIX_PATH=/opt/ros/$ROS_DISTRO
ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp
# ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/isaac-sim/exts/omni.isaac.ros2_bridge/humble/lib

RUN echo 'source /opt/ros/$ROS_DISTRO/setup.bash' >> /root/.bashrc
RUN echo 'source /home/code/install/local_setup.bash' >> /root/.bashrc
RUN echo 'source /usr/share/gazebo-11/setup.bash' >> /root/.bashrc
RUN echo 'export GAZEBO_MODEL_PATH=/home/code/src/custom_gazebo_env/:$GAZEBO_MODEL_PATH' >> /root/.bashrc
RUN echo 'source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash' >> /root/.bashrc
RUN echo 'export RMW_IMPLEMENTATION=rmw_fastrtps_cpp' >> /root/.bashrc

# RUN touch /home/${USERNAME}/.bashrc \
#     && cp /root/.bashrc /home/${USERNAME}/.bashrc