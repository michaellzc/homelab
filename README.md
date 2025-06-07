# homelab

Poor-man's Home Lab setup. Not production ready.

For common operations, refer to the [handbook](./handbook/).

## Philosophy

- Life is short, management overhead should be minimal.
- No HA, but periodic backups of the data drives or application-level data.
- Workloads are containerized and run on ephemeral Linux VMs; Configuration should be declarative and reproducible.
- No public ingress, all access is via Tailscale.

## Hardware

- Compute
  - Intel NUC 12 NUC12WSHi5
    - Windows Server 2025 running multiple Ubuntu VMs using Hyper-V as hypervisor
    - Intel Core i5-1240P (4P + 8E)
    - 2 x 4GB DDR4 RAM
    - 1 x Transcend 430S 512GB M.2 SATA SSD (OS drive)
    - 1 x WD Black SN750 1TB M.2 NVMe SSD (Data drive)
- Network
  - Ubiquiti UDM-Pro
  - Ubiquiti USW-Pro-Max-16-PoE
  - Ubiquiti USW-Flex-Mini

## Configuration management

The host OS is Windows Server, RDP is used occasionally to connect to the host in order to apply system updates / security patches, and run PowerShell scripts to provision VMs on Hyper-V. Otherwise, SSH from the MacBook is used for most operations on the VMs.

Ubuntu VMs are bootstrapped with cloud-init for common configuration, e.g., ssh keys, docker, tailscale. Each VM is assigned a unique name and accessible via Tailscale.

Upon VM creation, the magic DNS name from Tailscale is added to the inventory file and apply the ansible playbook to perform additional configuration.

List of VMs:

- Apps VM (`lab-vm-774e5d`)
  - k3s single-node cluster
  - Workloads are exposed via [Tailscale Kubernetes Operator](https://tailscale.com/kb/1236/kubernetes-operator)
  - Runs most containerized workloads, e.g., Homebridge
