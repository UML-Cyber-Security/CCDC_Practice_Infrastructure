# Security Onion install on VirtualBox VM

## Preparation
Download the following files:

`https://github.com/Security-Onion-Solutions/security-onion/releases/download/v16.04.6.2_20190826/securityonion-16.04.6.2.iso`

`https://github.com/Security-Onion-Solutions/security-onion/raw/master/sigs/securityonion-16.04.6.2.iso.sig`

`https://raw.githubusercontent.com/Security-Onion-Solutions/security-onion/master/KEYS`

## Verify the `.iso`:

In the same directory you saved the keys to, run `gpg --import KEYS`
Then verify the `.iso`:

`gpg --verify securityonion-16.04.6.2.iso.sig securityonion-16.04.6.2.iso`

The signature should match: `BD56 2813 E345 A068 5FBB  91D3 788F 62F8 ED6C F680`

If the signature does not match, the file cannot be trusted.

# Installation

## Boot the live image

If using VirtualBox:
- Create a new `NAT Network` by clicking the `+` sign in  `File->Preferences->Network`
    - Name it whatever you'd like. You'll be selecting this network later when configuring the VM.
- `Click` **`New`** on the VirtualBox toolbar
- Name it, ensure `Version` is `Debian (64-bit)`.
- Set `Machine Folder` to a drive that has more than `50 GB` of space
- **`Next`**
- Allocate `8192 MB` memory or more, **`Next`**.
- `Create a virtual hard disk now`, **`Create`**.
- In the `Create Virtual Hard Disk` dialog, select `VDI`, **`Next`**.
- Select `Dynamically allocated`, **`Next`**
- Allocate `40 GB+` for the drive, **`Create`**.
- Press `ctrl+H` to bring up the `Host Network manager` window.
  - `Create` a new network card and ensure `DHCP Server` is enabled.
- Open the settings menu for the new VM.
  - Allocate more cores through `System->Processor`
  - Set `Network 1` to `NAT Network` through `Network->Adapter1`
  - Enable the newly created adapter through `Network->Adapter2`
    - Attach to `NAT Network`
    - Reveal the advanced options and select `Allow All` for promiscuous mode, click `OK`
- `Click` **`Start`** on the VirtualBox toolbar.
- `Click` on the folder icon next to the dropdown bar in the `Select start-up disk` dialog, **`Open`**
- **`Start`**
- In the bootloader, select `Boot SecurityOnion 16.04.6.2`
- When the desktop environment loads, double click the `Install SecurityOnion 16.04` icon.
  
## Live installer
- Selection `English`, **`Continue`**
- Do not tick any of the update options, **`Continue`**
- `Erase disk and install SecurityOnion` should already be selected, **`Continue`**
  - Review the changes, and **`Continue`**
- Select `New York` for the time zone, **`Continue`**
- Keyboard layout should be `English (US)`,**`Continue`**. If the screen happens to be out of frame, just drag the window as needed.
- Create a user and `Install`
- `Restart Now` when installation completes
- When asked to remove installation media: On the VirtualBox toolbar, uncheck the `.iso` in `Devices->Optical Drives`
- Press `enter`

## VirtualBox Guest Additions and Wireless NIC
- When the VM is loaded, on the VirtualBox toolbar: `Devices->Insert Guest Additions CD image...`
- The VM will recognize the disc has been mounted and pop a dialog: `Run`
- Shutdown when finished
- Open the VirtualBox settings for the VM
  - Add a `USB 2.0 filter` for the Atheros chip, click `OK`
- Turn on VM

## Network setup
- Log in with the user created during installation
- Click the `Setup` icon
- `Yes, Continue!`
- `Yes, configure /etc/network/interfaces!`
- The NATed interface should be used for management, `enp0s3` in my case.
- Set `DHCP` addressing and click `OK`
- Set up a sniffing interface with the other NIC
- `Yes, make changes!`
- `Yes, reboot!`

##  Services setup
- Double click the `Setup` icon again
- `Yes, Continue!`
- `Yes, skip network configuration!`
- We don't have many resources. Choose `Evaluation mode` and `OK`.
- The sniffing interface should be monitored
- Create a username to use with the services and set a password for it
- `Yes, proceed with the changes!`
- Read through the dialog boxes as you click through them

## Updating
`soup` is SecurityOnion's update manager. It should only be updated with this tool.
- `sudo soup` and press `enter` when prompted. Could take a while.
  - `enter` when prompted to reboot
