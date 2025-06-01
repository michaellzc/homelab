# Hyper-V VM Role

This Ansible role provisions Hyper-V virtual machines using PowerShell Desired State Configuration (DSC) through the `win_dsc` module.

## Requirements

- Windows Server 2016 or later with Hyper-V role installed
- PowerShell 5.0 or later
- `qemu-img.exe` available in PATH for image conversion
- WinRM configured for Ansible connectivity

## Role Variables

### Required Variables

- `vm_name`: Name of the virtual machine
- `vm_root_password` OR `vm_root_public_key`: Authentication method for VM

### Image Source

- `vm_source_path`: Path to source cloud image (qcow2 format). If left empty, the role will automatically download Ubuntu 24.04 cloud image

### Ubuntu Image Auto-Download (when vm_source_path is empty)

- `vm_ubuntu_download_path`: Directory to download Ubuntu images (default: "C:\\Images")
- `vm_ubuntu_image_url`: Ubuntu cloud image base URL (default: Ubuntu 24.04 noble release)
- `vm_ubuntu_image_file`: Ubuntu image filename (default: "ubuntu-24.04-server-cloudimg-amd64.img")
- `vm_ubuntu_verify_checksum`: Verify SHA256 checksum after download (default: true)

### VM Configuration

- `vm_generation`: VM generation (default: 2)
- `vm_memory_startup_bytes`: Initial memory in bytes (default: 1GB)
- `vm_enable_dynamic_memory`: Enable dynamic memory (default: false)
- `vm_processor_count`: Number of virtual processors (default: 2)
- `vm_vhdx_size_bytes`: Resize VHDX to specified size (optional)

### Network Configuration

- `vm_switch_name`: Hyper-V switch name (default: "SWITCH")
- `vm_interface_name`: Primary interface name (default: "eth0")
- `vm_mac_address`: Static MAC address (optional)
- `vm_vlan_id`: VLAN ID (optional)

### IP Configuration

- `vm_fqdn`: Fully qualified domain name (default: vm_name)
- `vm_ip_address`: Static IP in CIDR format (e.g., "192.168.1.100/24") or empty for DHCP
- `vm_gateway`: Gateway IP address
- `vm_dns_addresses`: List of DNS servers (default: ["1.1.1.1", "1.0.0.1"])

### Secondary Network (Optional)

- `vm_secondary_switch_name`: Second Hyper-V switch
- `vm_secondary_interface_name`: Second interface name (default: "eth1")
- `vm_secondary_mac_address`: Static MAC for second interface
- `vm_secondary_ip_address`: Static IP for second interface
- `vm_secondary_vlan_id`: VLAN ID for second interface

### Additional Software

- `vm_install_docker`: Install Docker CE (default: false)
- `vm_tailscale_auth_key`: Tailscale auth key for automatic setup

## Example Playbook

```yaml
- hosts: hyperv_hosts
  roles:
    - role: hyperv_vm
      vm_name: "test-vm"
      # vm_source_path left empty to auto-download Ubuntu 24.04
      vm_root_password: "SecurePassword123!"
      vm_memory_startup_bytes: 2147483648  # 2GB
      vm_processor_count: 4
      vm_ip_address: "192.168.1.100/24"
      vm_gateway: "192.168.1.1"
      vm_install_docker: true
```

## Advanced Example with Secondary Network

```yaml
- hosts: hyperv_hosts
  roles:
    - role: hyperv_vm
      vm_name: "web-server"
      # Automatically downloads Ubuntu 24.04 to C:\Images
      vm_root_public_key: "ssh-rsa AAAAB3... user@host"
      vm_memory_startup_bytes: 4294967296  # 4GB
      vm_enable_dynamic_memory: true
      vm_processor_count: 2
      vm_switch_name: "External"
      vm_ip_address: "10.0.1.100/24"
      vm_gateway: "10.0.1.1"
      vm_secondary_switch_name: "Internal"
      vm_secondary_ip_address: "192.168.100.100/24"
      vm_install_docker: true
      vm_tailscale_auth_key: "tskey-auth-..."
```

## Dependencies

This role requires the Metadata-Functions.ps1 script or equivalent functionality to create cloud-init ISO images. The current implementation includes a placeholder that would need to be replaced with actual ISO creation logic.

## Features

- **Automatic Ubuntu 24.04 Download**: When `vm_source_path` is empty, automatically downloads the latest Ubuntu 24.04 LTS cloud image
- **Image Verification**: SHA256 checksum verification ensures downloaded images are intact
- **DSC-based Configuration**: Uses PowerShell Desired State Configuration for declarative VM management
- **Cloud-init Support**: Generates proper cloud-init configuration for Ubuntu VMs
- **Network Flexibility**: Supports both static IP and DHCP configurations with optional secondary networks

## License

MIT

## Author Information

Created for homelab automation using Ansible and Hyper-V.
