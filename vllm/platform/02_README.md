# Intel® Multi-GPU Base Platform Installer

This project provides an offline installation script for Intel® Multi-GPU evaluation environments. It sets up the required firmware, base libraries, GPU drivers, and the Intel® oneAPI Base Toolkit™ on either a host or container environment.

---

## Features

- Root user & directory verification
- Docker environment detection
- Firmware & GRUB modification for host environments
- Install GPU drivers
- Install Intel® oneAPI Base Toolkit™ (offline)
- Install evaluation tools (1CCL, GEMM, xpu-smi)
- Logs all output to a timestamped `.log` file

---

## Notes

1. This installer is built upon the official **Ubuntu® 25.04 Desktop ISO**.
2. After downloading, simply run `./installer.sh` to begin installation. Remember to verify the md5sum to ensure successful downloading.
3. It installs GPU drivers, base libraries, Intel® oneAPI Base Toolkit™, platform test tools, and several commonly used utility scripts.
4. The total package size is about **2.6 GB**, of which the **oneAPI installer accounts for 2.2 GB**. On an Intel® Xeon® W-2545 system, installation takes approximately **10 minutes**.
5. Supports execution in both **native host** environments and **Docker® containers**.
6. Installation **must be performed as the root user**.
7. After installation:
   - `gemm`, `1ccl`, and `xpu-smi` tools are installed to `/usr/bin`.
   - `level-zero-tests` is located at `./tools/level-zero-tests/`.
   - `ze_peer` is provided for P2P testing.
   - `ze_peak` is provided for H2D, D2H, and D2D bandwidth benchmarking.
   - All tools can be executed directly.
8. In **native environments**, the installer will:
   - Update GPU **GuC/HuC firmware**
   - Modify **GRUB** to disable **IOMMU**
   - A **system reboot is required** after installation for these changes to take effect.
9. No reboot is required when running inside Docker® containers.

---

## Usage

First, install a standard Ubuntu® 25.04:

- [Ubuntu® 25.04 Desktop](https://releases.ubuntu.com/25.04/ubuntu-25.04-desktop-amd64.iso) (recommended for Intel® Xeon® W-series)
- [Ubuntu® 25.04 Server](https://releases.ubuntu.com/25.04/ubuntu-25.04-live-server-amd64.iso) (recommended for Intel® Xeon® Scalable Processors)

If your system is not a fresh Ubuntu® 25.04 installation, the installer may fail. Switch to the root user and run the script.

> **Note:** For the August 2025 release, due to process constraints, this installer fetches the validated kernel **6.14.0-15-generic** from the internet to ensure consistency. Ensure your internet connection is active before proceeding. We aim to fully support offline kernel installation in the next release.

```bash
chmod +x installer.sh
sudo ./installer.sh
```

If successful, you will see:

```bash
[INFO] Intel® Multi-ARC base platform installation complete.
[INFO] Please reboot the system to apply changes.

Tools installed: gemm / 1ccl / xpu-smi in /usr/bin
level-zero-tests: ./tools/level-zero-tests
Support scripts: ./scripts
Installation log: ./install_log_<timestamp>.log
```

---

## Check Installation

Since GPU firmware and initramfs were updated, a **system reboot** is required for changes to take effect.

After rebooting, validate with `lspci` and `sycl-ls`:

```bash
lspci -tv | grep -i e211
```

```bash
source /opt/intel/oneapi/setvars.sh
sycl-ls
```

Successful detection of **Device ID: e211** by both tools indicates proper installation of kernel and user-mode GPU drivers.

---

## Using Tools

This script installs tools for GPU development:

- **level-zero-tests**: P2P and memory bandwidth benchmarks
- **xpu-smi**: GPU profiling and management
- **1CCL benchmark**: collective communication benchmark (allreduce, allgather, all2all)
- **GEMM benchmark**: matrix compute benchmarks using Intel® MKL with GPU acceleration

### Examples

#### GPU Discovery

```bash
xpu-smi discovery
```

#### Matrix Multiply Benchmark

```bash
source /opt/intel/oneapi/setvars.sh
matrix_mul_mkl int8 40960
```

#### Allreduce Benchmark (4 GPUs)

```bash
source /opt/intel/oneapi/setvars.sh
mpirun -np 4 /usr/bin/1ccl_benchmark -a gpu -m usm -u device -e in_order -l allreduce -i 50 -w 20 -f 512 -t 67108864 -j off -p 0 -d float16 -q 0 -o allreduce_outplace_128M.csv
```

---

## Using Scripts

### setup_perf.sh

Set CPU/GPU to performance mode:

```bash
cd ./scripts/evaluation/
./setup_perf.sh
```

### platform_basic_evaluation.sh

Run basic evaluation covering P2P, GEMM, and 1CCL benchmarks:

```bash
./scripts/evaluation/platform_basic_evaluation.sh
```

Results are saved under `./results/`. A sample report based on Intel® Xeon® W-2545 + 2× B60 GPUs is provided for **reference only**. It is **not** a performance claim or benchmark result.
Note that "GEMM benchmark" may need around **5 mins** to complete.

### collect_sysinfo.sh

To collect system diagnostics for Intel® support:

```bash
./scripts/debug/collect_sysinfo.sh
```

### run_gpu_container.sh

Run a GPU-enabled Docker® container. First parameter is docker image name, the second one is the directoy you want to mount to container.


```bash
./scripts/docker/run_gpu_container.sh ubuntu-25.04-base /home
```

---

## vLLM-based Inference

Follow the [User Guide](https://github.com/intel/llm-scaler/tree/main/vllm#11-pulling-and-running-the-vllm-docker-container) to set up vLLM inference with Intel® GPU acceleration.

---

© 2025 Intel Corporation. Intel, the Intel logo, Intel oneAPI, Xeon, and other Intel trademarks are trademarks of Intel Corporation or its subsidiaries. Other names and brands may be claimed as the property of others.
