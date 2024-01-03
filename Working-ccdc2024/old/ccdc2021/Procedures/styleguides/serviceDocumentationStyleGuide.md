# Style Guide with Explanations

```markdown
# [service_name]

## Objective

CONTENT // Description of what this documentation explains
STYLE //
Text

## Security Analysis

CONTENT // Analysis of specific vulnerability and how they are patched
STYLE //
- Brute forcing password authentication is possible against the ssh server remotely, could result in 
  - Enable asymetric key authentication
  - Set attempt limits
- Hash collisions from weak cryptographic algorithms are possible, may allow the attacker to steal a host file and perform a MITM
  - Disable SHA-1 as an option 

## Testing

Scripted: 

CONTENT // Tests that are integrated into the script-- what they test for, and the expected output
STYLE //
- Check if systemctl started the service without errors
  - Run systemctl status service name
  - Expect to see "Active: active (running)" in output

Active:

CONTENT // Tests that the user has to actively perform-- what they test for, why they can't be scripted, the steps to perform, and the expected output or result at each step
STYLE //
- Verify that the bios password prevents the bootloader order from changing immediately after restart
  - This test requires physical access to the machine before the operating system has started
  - Steps:
    - Reboot the computer
    - Access the bios
    - Attempt to change the boot order
    - Enter a random password
      - Expected: Password denied output
    - Enter the correct password
      - Expected: The bios should allow you to change the boot order

## Documentation

CONTENT // Unique terms, files, commands, items, entities, or what have you used in the service. If this service uses another specific service, reference that documentation, but do not include it here
STYLE //
- `sshd_config` File that holds configuration options used when the SSH server run
  - In the file these are the different configuration options
    - `Protocol 2` A specific ssh implementation that allow PKI 
    - `DenyUsers *` Sets the SSH server to deny all access
- `yum` Command to invole CentOS package manager, see CentOS installation documentation

## Script with Comments

CONTENT // A script in Python3, Powershell, Bash, etc that installs / secures the service-- Also include the script in the service directory WITHOUT the comments (for faster typing)
STYLE (Remove back slashes to render) //
\```bash
#!/bin/bash
#Install openssh for sshd and ssh, using the sync, repo upadte, and full system update pacman flags
sudo pacman -Syu openssh

#Make the empty config
touch sshd_config

#Cat the following text into the file using redirection with EOF
sudo cat <<EOF > sshd_config
#Do not allow client to choose 1, so we can use keys
Protocol 2

#Default deny all users until there is at least one for AllowUsers,
#   then remove DenyUsers and just add to AllowUsers
#AllowUsers
DenyUsers * 

EOF

#Replacing sshd_config
sudo rm /etc/ssh/sshd_config
sudo cp sshd_config /etc/ssh/
sudo rm sshd_config

#Verifying the config is operable
sudo sshd -t
\```

## ToDo

CONTENT // A list of items that still need to be completed for the documentation
STYLE //
- [x] Completed item  
- [ ] Un completed

## References

CONTENT // Hyperlinked references to essential documentation-- whatever you read to come to the solution
STYLE //
- [reference_hyper_link_text](url_to_reference)
```

# Rendered Markdown

Note: All headers and specifically bolded text must be the same in all documentation-- actual documentation may have bolded text at the authors discretion

____

# Arch SSH

## Objective

Text

## Security Analysis

- Brute forcing password authentication
  - Enable asymetric key authentication
  - Set attempt limits
- Hash collisions from weak cryptographic algorithms
  - Disable SHA-1 as an option 

## Testing

**Scripted:**

- Check if systemctl started the service without errors
  - **Steps:**
    - Execute command `systemctl status docker`
      - **Expected:** to see `Active: active (running)` in output

**Active:**

- Verify that the bios password prevents the bootloader order from changing immediately after restart
  - This test requires physical access to the machine before the operating system has started
  - **Steps:**
    - Reboot the computer
    - Access the bios
    - Attempt to change the boot order
    - Enter a random password
      - **Expected:** Password denied output
    - Enter the correct password
      - **Expected:** The bios should allow you to change the boot order

## Documentation

- `sshd_config` File that holds configuration options used when the SSH server run
  - In the file these are the different configuration options
    - `Protocol 2` A specific ssh implementation that allow PKI 
    - `DenyUsers *` Sets the SSH server to deny all access
- `yum` Command to invoke CentOS package manager, see CentOS installation documentation

## Script with Comments

```bash
#!/bin/bash
#Install openssh for sshd and ssh, using the sync, repo upadte, and full system update pacman flags
sudo pacman -Syu openssh

#Make the empty config
touch sshd_config

#Cat the following text into the file using redirection with EOF
sudo cat <<EOF > sshd_config
#Do not allow client to choose 1, so we can use keys
Protocol 2

#Default deny all users until there is at least one for AllowUsers,
#   then remove DenyUsers and just add to AllowUsers
#AllowUsers
DenyUsers * 

EOF

#Replacing sshd_config
sudo rm /etc/ssh/sshd_config
sudo cp sshd_config /etc/ssh/
sudo rm sshd_config

#Verifying the config is operable
sudo sshd -t
```

## ToDo

- [x] Completed item  
- [ ] Un completed

## References

- [reference_hyper_link_text](url_to_reference)
