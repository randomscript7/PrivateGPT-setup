# PrivateGPT-setup
### Shell script that automatically sets up privateGPT with ollama on Ubuntu

This script was created after updating the process of installing privateGPT, as found on this guide: https://medium.com/installing-privategpt-on-wsl-with-gpu-support-5798d763aa31.
It is functional as of October 2024, and will install the CUDA 12.6 drivers if GPU installation is chosen.

To run, simply execute the following:
```
git clone https://github.com/randomscript7/privateGPT-setup
cd PrivateGPT-setup
sudo chmod +x privateGPT-ollama.sh
sudo ./privateGPT-ollama.sh
```
