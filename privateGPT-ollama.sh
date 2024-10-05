#!/bin/bash

if test ~/privateGPT/setupDone.txt; then
    
    echo "PrivateGPT appears to have been already set up."
    echo "Starting existing program instead..."
    sleep 0.5
    make run ~/privateGPT/pyproject.toml

else

    echo "This script will, as of October 2024, install and set up PrivateGPT on WSL Ubuntu."
    echo "This script is NOT a fullly automatic setup script."
    echo "You will need to install the Nvidia CUDA drivers, as this script is for (Nvidia) GPU power, not CPU."
    read -p "Press enter to continue: " tmp
    echo "----------------"
    echo ""
    cd ~

    echo "Updating and upgrading your system..."
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install build-essential
    echo "Done."
    echo "----------------"
    echo ""

    echo "Cloning the privateGPT repository..."
    git clone https://github.com/imartinez/privateGPT
    echo "Done."
    echo "----------------"
    echo ""

    echo "Installing some dependencies..."
    sudo apt-get install git gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev libssl-dev openssl libffi-dev
    echo "Done."
    echo "----------------"
    echo ""

    echo "Getting pyenv..."
    curl https://pyenv.run | bash
    echo "Done."
    echo "----------------"
    echo ""

    export PATH="/home/scriptmonkey/.pyenv/bin:$PATH"

    #Add to .bashrc file {
    echo " export PYENV_ROOT="$HOME/.pyenv" " >> .bashrc
    echo " [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH" " >> .bashrc
    echo " eval "$(pyenv init -)" " >> .bashrc
    # }

    source .bashrc

    echo "Setting up lzma..."
    sudo apt-get install lzma
    sudo apt-get install liblzma-dev
    echo "Done."
    echo "----------------"
    echo ""

    echo "Setting up python 3.11..."
    pyenv install 3.11
    pyenv global 3.11
    pip install pip --upgrade
    pyenv local 3.11
    echo "Done."
    echo "----------------"
    echo ""

    echo "Downloading poetry via python3..."
    curl -sSL https://install.python-poetry.org | python3 -
    echo "Done."
    echo "----------------"
    echo ""

    #Add to .bashrc file {
    echo " export PATH="/home/scriptmonkey/.local/bin:$PATH" " >> .bashrc
    # }

    source /.bashrc

    # poetry --version # should display something without errors

    echo "Starting setup for llama..."
    cd privateGPT
    poetry install --extras "ui embeddings-huggingface llms-llama-cpp vector-stores-qdrant"
    echo "Done." 


    # Install Nvidia drivers from https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_network
    #{

    echo "Installing CUDA 12.6 drivers..."
    echo "Replace the commands in this file with those found in the following link for updated drivers."
    echo "https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_network"
    #Driver instructions for 12.6 {
    wget "https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb"
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-12-6
    # }
    echo "Done."

    #Add to .bashrc file {
    echo " export PATH="/usr/local/cuda-12.6/bin:$PATH" " >> ~.bashrc
    echo " export LD_LIBRARY_PATH="/usr/local/cuda-12.6/lib64:$LD_LIBRARY_PATH" " >> ~.bashrc
    # }

    source ~/.bashrc

    echo "The GPU drivers have been installed."
    echo "This script is currently incapable of troubleshooting if an error occurs."
    echo "All this will do is allow you to manually check for errors."
    read - p "Would you like to run <nvidia-smi.exe> and <nvcc --version> to check for errors? (y/n): " choice

    if [ "choice" = "y"]; then
        echo "----------------"
        echo "nvcc --version and nvidia-smi.exe will be run."
        echo "If there are no errors, the setup will be successful."
        nvcc --version
        echo ""
        echo "----------------"
        echo "If there were errors, something went wrong."
        read -p "If not, press Enter:" tmp
        nvidia-smi.exe
        echo ""
        echo "----------------"
        echo "If there were errors, something went wrong."
        read -p "If not, press Enter:" tmp

    else
        echo "Skipping verification..."
        sleep 0.5
    fi

    echo ""
    echo "----------------"
    echo "Installing llama-cpp-python via poetry..."
    CMAKE_ARGS='-DGGML_CUDA=on' poetry run pip install --force-reinstall --no-cache-dir llama-cpp-python

    poetry run python scripts/setup

    read -p "Setup has completed. To start privateGPT, press Enter: " tmp
    echo "Starting privateGPT on 127.0.0.1:8001..."
    sleep 2

    echo "This file means that llama has been set up on privateGPT. You may disregard it." > ~/privateGPT/setupDone.txt

    make run

    # If GPU offload is working, you should see blas = 1

    #PrivateGPT will be running on 127.0.0.1:8001, using a Nvidia GPU for computation power
    #This script was made after updating commands from this guide: medium.com/installing-privategpt-on-wsl-with-gpu-support-5798d763aa31

fi

exit 0