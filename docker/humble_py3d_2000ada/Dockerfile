FROM osrf/ros:humble-desktop-full


RUN  apt-get update && apt upgrade -y \
  && apt-get install -y wget python3-pip\
  && rm -rf /var/lib/apt/lists/*

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

# # CUB required for CUDA older than 11.7 https://github.com/facebookresearch/pytorch3d/blob/main/INSTALL.md
# RUN curl -LO https://github.com/NVIDIA/cub/archive/1.10.0.tar.gz
# RUN tar xzf 1.10.0.tar.gz
# ENV CUB_HOME=/cub-1.10.0

RUN apt-get update \
  && apt-get install -y software-properties-common \
  && rm -rf /var/lib/apt/lists/*

# # Downgrading gcc solves some pytorch3d compilation errors https://github.com/facebookresearch/pytorch3d/issues/1206
# RUN apt-get update \
#   && apt-get install -y gcc-10 g++-10 \
#   && rm -rf /var/lib/apt/lists/*

# Installing NVIDIA toolkit compatible with GPU driver and CUDA that you have installed on your pc
RUN wget https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda_12.4.0_550.54.14_linux.run

RUN sh cuda_12.4.0_550.54.14_linux.run --silent --toolkit
# RUN ln -s /usr/bin/gcc-10 /usr/local/cuda-12.4/bin/gcc
RUN  apt-get update \
  && rm -rf /var/lib/apt/lists/*

RUN pip install 'git+https://github.com/facebookresearch/pytorch3d.git@stable'

# # Install git lfs
# RUN wget https://github.com/git-lfs/git-lfs/releases/download/v3.5.1/git-lfs-linux-amd64-v3.5.1.tar.gz
# RUN tar -xvf git-lfs-linux-amd64-v3.5.1.tar.gz
# RUN cd git-lfs-3.5.1 && bash install.sh && cd .. && git lfs install
# RUN rm -r /git-lfs-*


# # # Install clang and related packages
# # RUN  apt-get update \
# #   && apt-get install -y libstdc++-12-dev clang \
# #   && rm -rf /var/lib/apt/lists/*

# # # O3DE additional libraries
# # RUN  apt-get update \
# #   && apt-get install -y libglu1-mesa-dev libxcb-xinerama0 libxcb-xinput0 libxcb-xinput-dev libxcb-xfixes0-dev \
# #   libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev libfontconfig1-dev libpcre2-16-0 zlib1g-dev mesa-common-dev \
# #   libunwind-dev libzstd-dev \
# #   && rm -rf /var/lib/apt/lists/*

# # # Install ninja-build
# # RUN  apt-get update \
# #   && apt-get install -y ninja-build \
# #   && rm -rf /var/lib/apt/lists/*

# # #INSTALLING O3DE
# # RUN wget https://o3debinaries.org/main/Latest/Linux/o3de_2310_3.deb

RUN  apt-get update \
  && apt-get install -y ros-humble-joint-state-publisher-gui \
  ros-humble-ros2-control ros-humble-ros2-controllers ros-humble-gazebo-ros2-control ros-humble-gazebo-plugins \ 
  libnlopt-dev libnlopt-cxx-dev \
  && rm -rf /var/lib/apt/lists/*

# # COPY ./ros_entrypoint.sh /
# # RUN chmod +x /ros_entrypoint.sh

RUN pip install opencv-python
RUN pip install pyrender numpy-stl tikzplotlib numpy-quaternion

# Installation of SW for OAK D-POE
RUN  apt-get update && \
apt-get install -y iputils-ping ros-humble-depthai-ros\
&& rm -rf /var/lib/apt/lists/*
RUN pip install depthai


# Installation of Xauthority to allow gui visualization through docker using laptop's key
RUN  apt-get update && apt upgrade -y \
     && apt-get install -y xauth unzip \
     && rm -rf /var/lib/apt/lists/*

RUN echo 'xauth merge /dot.Xauthority' >> /root/.bashrc

# Create a non-root user
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# Set up sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
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

# WORKDIR /
# RUN wget -O ZED_SDK_Ubuntu22_cuda12.1_v4.0.8.zstd.run https://download.stereolabs.com/zedsdk/4.0/cu121/ubuntu22
# RUN sh ZED_SDK_Ubuntu22_cuda12.1_v4.0.8.zstd.run -- silent

# WORKDIR /home/code/src
# RUN git clone -b humble-v4.0.8 https://github.com/stereolabs/zed-ros2-wrapper.git
# RUN cd zed-ros2-wrapper && git submodule update --init --recursive
# WORKDIR /home/code

# RUN  apt-get update && apt upgrade -y \
#      && rosdep update && rosdep install --from-paths src --ignore-src -r -y \
#      && rm -rf /var/lib/apt/lists/*

## RUN  /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.sh; colcon build"

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

# Installing Ros middleware protocol zenoh
RUN apt-get update \
    && sudo apt-get install -y \
    ros-$ROS_DISTRO-rmw-zenoh-cpp \
    ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
    && rm -rf /var/lib/apt/lists/*

RUN sudo pip uninstall opencv-python -y && \
sudo pip install opencv-python-headless && \
pip install rosbags

RUN  apt-get update && apt upgrade -y \
     && sudo apt-get install -y \
     ffmpeg \
     && rm -rf /var/lib/apt/lists/*


RUN echo 'source /opt/ros/$ROS_DISTRO/setup.bash' >> /root/.bashrc
RUN echo 'source /home/code/install/local_setup.bash' >> /root/.bashrc
RUN echo 'source /usr/share/gazebo-11/setup.bash' >> /root/.bashrc
RUN echo 'export GAZEBO_MODEL_PATH=/home/code/src/custom_gazebo_env/:$GAZEBO_MODEL_PATH' >> /root/.bashrc
RUN echo 'export GAZEBO_PLUGIN_PATH=/home/code/install/ros2_linkattacher/lib/:$GAZEBO_PLUGIN_PATH' >> /root/.bashrc
RUN echo 'source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash' >> /root/.bashrc
RUN echo 'export RMW_IMPLEMENTATION=rmw_zenoh_cpp' >> /root/.bashrc
RUN touch /home/${USERNAME}/.bashrc \
    && cp /root/.bashrc /home/${USERNAME}/.bashrc