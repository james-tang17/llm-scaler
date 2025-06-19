#!/bin/bash
 
# Environment Setup Script for Intel GPU Multi-Arch Development
# Run this script as root to ensure consistent environment
 
if [ "$(id -u)" -ne 0 ]; then
  echo "[ERROR] This script must be run as root. Exiting."
  exit 1
fi
 
# Enable strict mode
set -euo pipefail
trap 'echo "[ERROR] Script failed at line $LINENO."' ERR
 
# Output both to terminal and log file
exec > >(tee -i /var/log/multi_arc_setup_env.log) 2>&1
 
echo -e "\n[INFO] Starting environment setup..."
 
WORK_DIR=~/multi-arc
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
 
# Proxy settings (optional, adjust as needed)
export https_proxy=http://child-prc.intel.com:913
export http_proxy=http://child-prc.intel.com:913
export no_proxy=127.0.0.1,*.intel.com
 
# Internet access check
echo "[INFO] Testing internet access..."
if ! curl -s --connect-timeout 10 https://www.google.com >/dev/null; then
  echo "[WARNING] Internet access through proxy may be unavailable."
fi
 
echo -e "\n[INFO] Installing base libraries..."
apt update
apt install -y vim clinfo build-essential hwinfo net-tools openssh-server curl pkg-config flex bison libelf-dev libssl-dev libncurses-dev git libboost1.83-all-dev cmake libpng-dev docker.io docker-compose-v2
 
echo -e "\n[INFO] Adding Intel repository and graphics-testing PPA..."
if [ ! -f /usr/share/keyrings/oneapi-archive-keyring.gpg ]; then
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null
fi
 
echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list
add-apt-repository -y ppa:kobuk-team/intel-graphics-testing
apt update
 
echo -e "\n[INFO] Downloading and installing GPU firmware..."
FIRMWARE_DIR=$WORK_DIR/firmware
mkdir -p "$FIRMWARE_DIR"
cd "$FIRMWARE_DIR"
rm -rf ./*
wget https://gitlab.com/kernel-firmware/linux-firmware/-/raw/main/xe/bmg_guc_70.bin
wget https://gitlab.com/kernel-firmware/linux-firmware/-/raw/main/xe/bmg_huc.bin
zstd -1 bmg_guc_70.bin -o bmg_guc_70.bin.zst
zstd -1 bmg_huc.bin -o bmg_huc.bin.zst
 
if [ -d /lib/firmware/xe ]; then
  cp *.zst /lib/firmware/xe
else
  echo "[ERROR] /lib/firmware/xe does not exist. Ensure your system supports Xe firmware."
  exit 1
fi
 
echo -e "\n[INFO] Installing GPU base libraries..."
apt install -y libigdgmm12=22.7.2-0ubuntu1~25.04~ppa1 libigc2=2.11.9-1144~25.04
 
echo -e "\n[INFO] Installing Compute libraries..."
apt install -y libze1 libze-dev libze-intel-gpu1 intel-opencl-icd libze-intel-gpu-raytracing
 
echo -e "\n[INFO] Installing Thread Building Blocks (TBB)..."
apt install -y libtbb12=2022.0.0-2 libtbbmalloc2=2022.0.0-2
 
echo -e "\n[INFO] Installing Media SDK and related drivers..."
apt install -y intel-media-va-driver-non-free=25.2.2-0ubuntu1~25.04~ppa1
apt install -y vainfo=2.22.0+ds1-2
apt install -y libvpl2=1:2.15.0-0ubuntu1~25.04~ppa2
apt install -y libvpl-tools=1.4.0-0ubuntu1~25.04~ppa1
apt install -y libmfx-gen1=25.2.2-0ubuntu1~25.04~ppa1
apt install -y libmfx-gen-dev=25.2.2-0ubuntu1~25.04~ppa1
apt install -y va-driver-all=2.22.0-3ubuntu2
 
echo -e "\n[INFO] Installing XPU manager libraries..."
apt install -y libmetee4=4.3.0-0ubuntu1~25.04~ppa1
apt install -y intel-gsc=0.9.5-0ubuntu1~25.04~ppa1
apt install -y intel-metrics-discovery=1.14.180-0ubuntu1~25.04~ppa1
apt install -y intel-metrics-library=1.0.196-0ubuntu1~25.04~ppa1
 
echo -e "\n[INFO] Installing Mesa graphics libraries..."
apt install -y libegl-mesa0=25.0.3-1ubuntu2
apt install -y libegl1-mesa-dev=25.0.3-1ubuntu2
apt install -y libgl1-mesa-dri=25.0.3-1ubuntu2
apt install -y libgles2-mesa-dev=25.0.3-1ubuntu2
apt install -y libglx-mesa0=25.0.3-1ubuntu2
apt install -y libxatracker2=25.0.3-1ubuntu2
apt install -y mesa-va-drivers=25.0.3-1ubuntu2
apt install -y mesa-vdpau-drivers=25.0.3-1ubuntu2
apt install -y mesa-vulkan-drivers=25.0.3-1ubuntu2
 
echo -e "\n[INFO] Installing Intel OneAPI base toolkit..."
apt install -y intel-oneapi-base-toolkit=2025.1.3-6
 
echo -e "\n[INFO] Cloning and building level-zero-tests..."
cd $WORK_DIR
rm -rf level-zero-tests
git clone https://github.com/oneapi-src/level-zero-tests.git
cd level-zero-tests
git checkout 6f4258713c57ed1668671e5c016633624602184d
mkdir build && cd build
cmake ..
make -j$(nproc)
 
echo -e "\n[INFO] Creating setup_perf.sh..."
cd $WORK_DIR
cat << 'EOF' > setup_perf.sh
#!/bin/bash
gpu_num=$(sudo xpu-smi discovery | grep card | wc -l)
for((i=0; i<$gpu_num; i++)); do
  echo "Set GPU $i freq to 2400Mhz"
  sudo xpu-smi config -d $i -t 0 --frequencyrange 2400,2400
done
 
echo "Set CPU to performance mode"
echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
echo 0 | sudo tee /sys/devices/system/cpu/cpu*/power/energy_perf_bias
EOF
 
chmod +x setup_perf.sh
 
echo -e "\n[INFO] Configuring user groups and Wayland settings..."
gpasswd -a ${USER} render || true
if [ -f /etc/gdm3/custom.conf ]; then
  sed -i "s/^#*WaylandEnable=.*/WaylandEnable=true/" /etc/gdm3/custom.conf
fi
update-initramfs -u
 
echo -e "\n[INFO] Disabling intel_iommu..."
GRUB_FILE="/etc/default/grub"
if [ -f "$GRUB_FILE" ]; then
  cp "$GRUB_FILE" "${GRUB_FILE}.bak"
  sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=off"/' "$GRUB_FILE"
  update-grub
else
  echo "[ERROR] Could not find $GRUB_FILE"
  exit 1
fi
 
echo -e "\n Tools and scripts are located at /root/multi-arc."
echo -e "\n✅ [DONE] Environment setup complete. Please reboot your system to apply changes."
