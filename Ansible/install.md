# Installation on Ubuntu 

### Install PIP

Ubuntu

    sudo apt install python3-pip

### Install Ansible

    python3 -m pip install --user ansible

### If not on path, add with

    export PATH="$PATH:/wherever/it/installed"

Would be something like

    export PATH="$PATH:/usr/local/bin"

### Testing

    ansible-playbook -i hosts.ini <playbook>

    ansible all -i hosts.ini -m ping