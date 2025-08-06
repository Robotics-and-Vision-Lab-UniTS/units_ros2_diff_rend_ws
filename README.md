# /units_ros2_diff_rend_ws
Workspace containing all the modules of the projects at units for the differentiable rendering pipeline needed to reproduce the results of the paper "Differentiable Rendering for Visual Servoing" by A. Fabris, C. Dorigo, E. Salvato and F. A. Pellegrino.
For how to launch the different nodes check [the respective repo](https://github.com/Robotics-and-Vision-Lab-UniTS/differential_rendering).

## Ros2 RMW
The rmw is the middleware used by ros to communicate over the network. In the docker container used, during testing `rmw_zenoh_cpp` was used because of its [better perfomance](https://discourse.ros.org/t/zenoh-performance/30494). In this case though, differently from the other middlewares you MUST remember to run the router before running any other node, this router will be responsible for managing the communication among different nodes. To launch the router open a separate shell and run:
```
ros2 run rmw_zenoh_cpp rmw_zenohd 
```
## Docker
The container in this repository is crucial to develop in this workspace, and are designed to work in the VSCode IDE. So far they have been tested on the following machines:
* DELL Precision 5490 (GPU 2000 ADA);
* DELL Inspiron 15 7000 (GPU MX130).

Since the programs inside this image will require access to GPU, the Dockerfile might need a little tweak.  
So far the main repo of this branch is `fr10`. It contains all the submodules needed to do *pick and place* operations, *differentiable rendering for visual servoing* and many more things. However, each submodule can be used also independetly depending on the project at hans. Therefore feel free to checkout to a new branch and good luck with your project!

:warning: **WARNING** :warning:  
The docker image is quite heavy (30 to 40ish GB) because it's not optimized at all, and is thought to be something with very wide development scope in mind.

### Your PC setup
To leverage NVIDIA GPU, remember to:
* install `nvidia-container-toolkit`
* Configure the container runtime by using the `nvidia-ctk` command

Following [NVIDIA installation guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

### Container setup
To install all the requirements of pytorch3d stick to the [pytorch3d guide](https://github.com/facebookresearch/pytorch3d/blob/main/INSTALL.md) with the following extra precautions:
* `CUDA_HOME` should be set to your version of CUDA which is installed on your PC in `/usr/local/cuda-x.y`  
* `torch` and `torchvision` must be installed with the according CUDA version compatibile with your HW. To check the CUDA version execute: `nvidia-smi`, then select the corrisponding torch version from [pytorch archive](https://pytorch.org/get-started/previous-versions/)  
* `CUB_HOME` required for CUDA older than 11.7  
* According to [this github issue](https://github.com/facebookresearch/pytorch3d/issues/1206), downgrading gcc solves some pytorch3d compilation errors
* Install NVIDIA toolkit compatible with GPU driver and CUDA that you have installed on your pc, you can find the right runtime file in the [CUDA Toolkit Archive](https://developer.nvidia.com/cuda-toolkit-archive)  
* `TORCH_CUDA_ARCH_LIST` sets the GPU architecture required to compile torch related libraries. To find out which is your architecture you can run the python script `python3 docker/py_checks/print_GPU_cuda_info.py`, something similar to the following output should appear:
```
[
  {
    "name": "NVIDIA GeForce MX130",
    "compute_capability": [
      5,
      0
    ],
    "cores": 3,
    "concurrent_threads": 6144,
    "gpu_clock_mhz": 1189.0,
    "mem_clock_mhz": 2505.0,
    "total_mem_mb": 4046.0625,
    "free_mem_mb": 3574.4375,
    "architecture": "maxwell",
    "cuda_cores": 384
  }
]
```
In this example `TORCH_CUDA_ARCH_LIST=Maxwell` (architecture explanation [here](https://en.wikipedia.org/wiki/CUDA)).

Before testing the SW you can verify that the torch installation was successfull by executing `python3 docker/py_checks/verify_installation.py`.
