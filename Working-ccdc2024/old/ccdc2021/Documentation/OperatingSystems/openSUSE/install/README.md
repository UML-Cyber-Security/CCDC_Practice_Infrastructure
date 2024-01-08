# OpenSUSE install on VirtualBox VM

## Preparation
Download the following files:

`https://download.opensuse.org/distribution/leap/15.1/iso/openSUSE-Leap-15.1-DVD-x86_64.iso`

`https://download.opensuse.org/distribution/leap/15.1/iso/openSUSE-Leap-15.1-DVD-x86_64.iso.sha256`

## Verify the checksum file

`gpg --recv-keys 0x22C07BA534178CD02EFE22AAB88B2FD43DBDC284`

`gpg --fingerprint "openSUSE Project Signing Key <opensuse@opensuse.org>"`

`gpg --verify openSUSE-Leap-15.1-DVD-x86_64.iso.sha256`

Output will look like this:

```
gpg: Signature made Fri 21 Jul 2017 11:10:22 BST using RSA key ID 3DBDC284
gpg: Good signature from "openSUSE Project Signing Key <opensuse@opensuse.org>"                                                                                               
gpg: WARNING: This key is not certified with a trusted signature!                                                                                                             
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 22C0 7BA5 3417 8CD0 2EFE  22AA B88B 2FD4 3DBD C284
```

At the time of writing, the fingerprint should match the following:

`22C0 7BA5 3417 8CD0 2EFE 22AA B88B 2FD4 3DBD C284`

If it doesn't, the checksum cannot be trusted.

## Verify the `.iso`:

`sha256sum -c  openSUSE-Leap-15.1-DVD-x86_64.iso.sha256`

should produce the output:

`openSUSE-Leap-15.1-DVD-x86_64.iso: OK`

If checksums do not match, the file cannot be trusted.

# Installation

## Boot the live image

If using VirtualBox:
- `Click` **`New`** on the VirtualBox toolbar
- Name it, ensure `Version` is `openSUSE (64-bit)`.
- Set `Machine Folder` to a drive that has more than `50 GB` of space
- **`Next`**
- `8192 MB` memory, **`Next`**.
- `Create a virtual hard disk now`, **`Create`**.
- In the `Create Virtual Hard Disk` dialog, select `VDI`, **`Next`**.
- Select `Dynamically allocated`, **`Next`**
- Allocate `40 GB` for the drive, **`Create`**.
- `Click` **`Start`** on the VirtualBox toolbar.
- `Click` on the folder icon next to the dropdown bar in the `Select start-up disk` dialog, **`Open`**
- **`Start`**
  
## Live installer

- Wait for the bootloader to initialize.

- Use the arrow keys and `enter` to select `Installation`
  - Wait for the installer to initialize
- Language is `English (US)` by default, **`Next`**
- Select `Yes` when asked to activate online repositories.
  - Default options are fine, **`Next`**
- In the `System Role` menu, select `Server`. **`Next`**
- `Click` on the `Expert Partitioner` dropdown, select `Start with Current Proposal`.
- On the partition table viewer, find the storage device of type `Linux Native`.
  - `Click` on that storage device in the  `System View` list on the left. **`Edit`**
  - Check `Enable Snapshots` and `Encrypt Device`. **`Next`**
  - Enter a password. Losing this means losing access to the system. **`Next`**
  - **`Accept`**, **`Next`**
- Default options will probably be fine, ensure the correct time zone is set. **`Next`**
- Create a user. Uncheck `Use this password for system administrator` and `Automatic Login`. **`Next`**
- Create a different root user password, don't forget it. **`Next`**
- Review the settings and **`Install`**

Log in as the user created during installation.

Give yourself full root privileges

Lock the root account:

`sudo passwd -l root`