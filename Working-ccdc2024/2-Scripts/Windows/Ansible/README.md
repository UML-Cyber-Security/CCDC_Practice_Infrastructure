# Ansible

## [1.1] Windows 

### Important Commands

1. Add public key to authorized_keys on all machines: ``ssh-copy-id -i ~/.ssh/id_rsa.pub``
2. Test connection to machines: ``ansible all -u user -m ping -i inventory.yaml``
3. View hosts with: ``ansible all -i inventory.yaml --list-hosts``
4. You can run the playbook like this:
```ansible-playbook -u user -i inventory.yaml Windows.yml```

## [1.2] Linux

### Important Commands

```ansible-playbook -u user -i inventory.yaml Windows.yml```
