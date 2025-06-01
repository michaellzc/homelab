# Install Windows Server 2025 on Intel NUC

Installation guide for Windows Server 2025 on Intel/ASUS NUC 12 Pro 12 NUC12WSK.

## Install the OS using a USB drive

https://learn.microsoft.com/en-us/windows-server/get-started/install-windows-server?tabs=format-ntfs,desktop-experience&pivots=windows-server-2025#create-a-bootable-usb-flash-drive

Upon installation, update the server name to something meaningful, e.g., `NUC12`.

## Install NIC driver

Intel NUC 12 non-vPro variants come with i226-V NIC insteaad of i226-LM NIC. I226-V is a consumer-grade adapter (unlike i226-LM), and Windows Server blocks such device from the driver. In other words, the same dirver works for Windows 10/11, but not on Windows Server.

It's a hassle to self-signed the driver to trick the system like some posts suggested or risk installaing random drivers from the internet, here's a workaround:

- Open `Device Manager`
- Check `Network adapters` and confirm the I226-V is not listed (if a `Ethernet Controller` device is listed, skip the rest of this section)
- Go to `Other devices`, you should see a device named `Ethernet Controller`
- Click `Update driver` on the right-click menu
- Select `Browse my computer for drivers`
- Select `Let me pick from a list of available drivers on my computer`
- Select `Intel(R) Ethernet Connection I226-LM` from the list
- Click through all the scary warnings about potential incompatibility, go ahead and install the driver
- Confirm the adapter is now listed under `Network adapters` and working properly

For the wireless adapter, you can install the latest driver from [ASUS support](https://www.asus.com/us/displays-desktops/nucs/nuc-kits/asus-nuc-12-pro/helpdesk_download?model2Name=ASUS-NUC-12-Pro-Kit-NUC12WSH). They should work as is unlike the LAN driver.

## Configure the Windows Server

Enable the following features in the setup wizard from `Server Manager`:

- Remote Desktop Services
- OpenSSH.Server
- OpenSSH.Client
- Hyper-V
  - Select the ethernet adapter for virtual switch. You can rename it to something meanful later in the Hyper-V Manager.
- WSL

Or more as needed.

## Configure OpenSSH client

Open Terminal:

```powershell
ssh-keygen -C "mlzc@hey.com"
```

## Configure OpenSSH server

Follow https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui&pivots=windows-server-2025#enable-openssh-for-windows-server-2025

Add trsuted public keys to `C:\ProgramData\ssh\administrators_authorized_keys`.

Create `C:\ProgramData\ssh\sshd_config` with the following content:

```
AllowGroups Administrators
```

Open `Task Manager` to restart the `sshd` service.

## Install 1Password

https://1password.com/downloads/windows

## Install Tailscale

https://tailscale.com/kb/1022/install-windows

Make sure to check `Run unattended` under `Preferences` menu.

## Wrapping up

Confirm RDP and SSH works from another machine over tailnet, move the machine to the desired location.

From this point, all operations on the Windows Server will be done remotely.
