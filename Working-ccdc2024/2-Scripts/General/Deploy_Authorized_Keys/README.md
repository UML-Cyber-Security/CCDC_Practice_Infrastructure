# Ansible Playbook to Copy Public Keys to Machine

## Usage

1. Create file with authorized_keys
2. `ansible-playbook -i <inventory-file> deploy_authorized_keys.yml --ask-pass  `
3. Enter password for each machine
