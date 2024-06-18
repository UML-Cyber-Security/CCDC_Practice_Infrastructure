# Apline Linux Virtual Machine installation on VirtualBox

## Preparation
Download the following files:

`http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/x86_64/alpine-extended-3.10.3-x86_64.iso.sha256`

`http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/x86_64/alpine-extended-3.10.3-x86_64.iso`

## Verify the `.iso`:

`sha256sum -c alpine-extended-3.10.3-x86_64.iso.sha256`

If it doesn't, the checksum cannot be trusted.


should produce the output:
`alpine-extended-3.10.3-x86_64.iso: OK`

If checksums do not match, the file cannot be trusted.

## VM Setup
- `Click` **`New`** on the VirtualBox toolbar
- Name it
  - type: `Linux`
  - version: `Other Linux(64-bit)`
- Set `Machine Folder` to a drive that has more than `50 GB` of space
- **`Next`**
- `2048 MB` memory, **`Next`**.
- `Create a virtual hard disk now`, **`Create`**.
- In the `Create Virtual Hard Disk` dialog, select `VDI`, **`Next`**.
- Select `Dynamically allocated`, **`Next`**
- Allocate `8 GB` for the drive, **`Create`**.
- `Click` **`Start`** on the VirtualBox toolbar.
- `Click` on the folder icon next to the dropdown bar in the `Select start-up disk` dialog.
  - Select the alpine .iso, **`Open`**
- **`Start`**

## Installation

### System Setup
- only user is a password-less `root` by default
- begin the installation with the `setup-alpine` command
- Select keyboard layout
  - `us`, variant: `us-alt-intl`
- Give it a hostname of your choosing
- Network interface should be detected by default. The interface name will be in brackets as the default selection. In my case, it's: `[eth0]`
- Use `dhcp` for assigning an IP
- No manual network configuration is needed
- Set a root password
- Set the timezone, `EST`
- No proxy is needed
- `chrony` is fine for NTP service
- Select a random mirror or enter `f` to search for the fastest.
  - Usually faster to just pick one
- Use `openssh`

**This step is where you actually write the install to disk**
- Available disks will be listed
  - Enter the disk name, `sda` in my case.
  - select `sys` mode to save installation to disk
  - `y` to accept the changes
- On the VirtualBox menu bar, click on `Devices->Optical Drives` and unmount the Alpine Linux `.iso`. You can force unmount if given the option
- `reboot` your VM with the `reboot` command or through VirtualBox
- Log in with the root password your created

### Software installation
- `apk add git` to install `git`
- See [Git Server Setup](../services/git) for secure setup details


