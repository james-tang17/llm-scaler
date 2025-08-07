# 25.32.1.2 (V1.0)
The first release of offline installer for Intel Battlematrix project with multiple Battlemage GPUs (B60 Pro).

The target is to simply and unify the software installation and meanwhile to avoid the slow speed by accessing Ubuntu PPA repo by previous online installer.

Version Naming:
25 → 2025, 32 → ww32, 1 → major version, 2 → minor version

Contents:
- Base libraries including latest docker tools
- Graphics driver for B60 Pro
- Intel oneapi-base-toolkit
- Tools including 1ccl, ze_peak, ze_peer, gemm, xpu-smi
- Often used scripts
- Reference platform_basic_evaluation.sh report including benchmark of GPU P2P over PCIe, Collecitve Communication, GPU memory BW, GEML.
