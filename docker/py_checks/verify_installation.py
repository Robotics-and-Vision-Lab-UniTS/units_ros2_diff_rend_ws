# importing torch  
import torch

cuda_available=torch.cuda.is_available()

if (cuda_available):
    # get index of currently selected device
    print(f"current_device: {torch.cuda.current_device()}") # returns 0 in my case
    # get number of GPUs available  
    print(f"device_count: {torch.cuda.device_count()}") # returns 1 in my case
    # get the name of the device  
    print(f"device_name: {torch.cuda.get_device_name(0)}")
    # get list of compiled atchitecture
    # https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/
    print(f"arch list{torch.cuda.get_arch_list()}")

print(f"is cuda available: {cuda_available}")
