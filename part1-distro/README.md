# Part 1 — Custom Zena: Custom Distro based on Linux Mint 22.3

## Group Members
- Cristopher — Cubic configuration and modifications

## Base Used
- **Base distro:** Linux Mint 22.3 Cinnamon 64-bit
- **Codename:** Zena
- **Tool:** Cubic (Custom Ubuntu ISO Creator)

## Modifications Made

### 1. Firefox → Brave Browser
- **What was done:** Firefox was removed and Brave Browser was installed from its official repository.
- **Justification:** Brave is an open-source privacy-focused browser that blocks ads and trackers by default, with no third-party telemetry.

### 2. VSCodium preinstalled
- **What was done:** VSCodium was installed from its official repository.
- **Justification:** VSCodium is the free/libre build of VS Code without Microsoft telemetry or tracking, ideal for privacy-respecting software development.

### 3. Mint-Y-Dark theme set as default
- **What was done:** dconf was configured to apply the Mint-Y-Dark dark theme to all new users via /etc/skel.
- **Justification:** Improves the default visual experience and demonstrates persistent customization for new system users.

## Generated ISO
| Field | Value |
|---|---|
| File | linuxmint-22.3.0-2026.06.25-cinnamon-64bit-hwe-6.17.iso |
| Size | 3.20 GB |
| MD5 Checksum | 642a3c96a04ea04fd34235339fa2d831 |
| Directory | /home/cristopher/cubic-proyecto/ |

## How to Reproduce
1. Install Cubic: `sudo apt-add-repository ppa:cubic-wizard/release && sudo apt install cubic`
2. Open Cubic and select the Linux Mint 22.3 base ISO
3. Inside the chroot, run the commands for each modification
4. Generate the ISO with XZ compression

## Boot Screenshots
<img width="403" height="365" alt="image" src="https://github.com/user-attachments/assets/0c01d7a5-eb1c-4f02-8a15-d1bb1b8904d7" />
<img width="401" height="362" alt="image" src="https://github.com/user-attachments/assets/a00843b3-934f-4c6f-af0a-a33550b4f1dc" />
<img width="402" height="359" alt="image" src="https://github.com/user-attachments/assets/96c755e4-7a07-4b32-9cd9-c3a35bb842d0" />



