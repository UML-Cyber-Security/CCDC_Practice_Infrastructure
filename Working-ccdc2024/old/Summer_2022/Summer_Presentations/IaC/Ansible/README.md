# Ansible
## Inventory
```host
SERVER.FQDN
SERVER.IP

[GROUP_ONE]
SERVER.GROUP.ONE

ALIAS_NAME ansible_host=SERVER.ONE

[GROUP_TWO]
ALIAS_NAME

[GROUP_GROUP:children]
GROUP_ONE
GROUP_TWO
```

### Inventory Parameters
| Name               | Value                     |
| ------------------ | ------------------------- |
| ansible_host       | FQDN or IP Address        |
| ansible_connection | ssh, winrm, localhost     |
| ansible_port       | 22, 5986, etc.            |
| ansible_user       | root, administrator, etc. |
| ansible_ssh_pass   | SSH Password              | 
| ansible_password   | Windows Password          |

### Dynamic Inventory
Scripts can be used to generate the inventory dynamically
```bash
ansible-playbook -i inventory.txt playbook.yaml
ansible-playbook -i inventory.py playbook.yaml
```

## Ansible Run
```bash
ansible <hosts> -a <command> -i inventory.txt

ansible <hosts> -m <module> -i inventory.txt
```

## Playbooks
```bash
ansible-playbook <playbook name> -i inventory.txt
```

```yaml
-
    name: <play name>
    hosts: <hosts>
    tasks:
        - name: <task name>
          <module>:
```

### Modules
[Ansible Modules](https://docs.ansible.com/ansible/latest/plugins/module.html)
```yaml
-
    name: <play name>
    hosts: <hosts>
    tasks:
        - name: <task name>
          <module>:
              <key>: <value>
```

#### System
- User
- Group
- Hostname
- Iptable
- Lvg
- Make
- Mount
- Systemd
- Service

#### Commands
- Command
- Expect
- Raw
- Script
- Shell

#### Files
- Acl
- Archive
- Copy
- File
- Find
- Replace
- Template

#### Database
- Mongodb
- Mysql
- Postgresql

#### Cloud
- Amazon
- Azure
- Google
- Docker
- VMware

#### Windows
- Win_copy
- Win_command
- Win_shell
- Win_service
- Win_user


### Variables
Templating called **Jinja2 Templating**
When a variable is alone `key: {{ var }}` requires quotes -> `key: '{{ var }}'`
#### Playbook
```yaml
-
    name: <play name>
    hosts: <hosts>
    vars:
        <variable_key>: <value>
    tasks:
        - name: <task name>
          <module>:
              <module_key>: '{{ variable_key }}'
```
#### Inventory File
```
ALIAS_NAME ansible_host=SERVER.ONE <key>=<value>
```
#### Variable File
Available to the playbook when run
```yaml
<key>:<value>
<key>:<value>
```

### Conditionals
```yaml
-
    name: <play name>
    hosts: <hosts>
    tasks:
        -
            name: <task name>
            <module>:
                <key>: <value>
            when: <key> == <value>
        -
            name: <task name>
            <module>:
                <key>: <value>
            when: <key> == <value> or
                  <key> == <value2>
        -
            name: <task name>
            <module>:
                <key>: <value>
            when: <key> == <value> and
                  <key> == <value2>
```

#### When
```yaml
-
    name: <play name>
    hosts: <hosts>
    vars:
        packages:
            - name: foo
              required: True
            - name: bar
              required: False
    tasks:
        -
            name: Install {{ item.name }} on server
            apt:
                name: "{{ item.name }}"
                state: present
            when: item.required == True
            loop "{{ packages}}"
```

### Register
Put the output of a module into a variable.
```yaml
-
    name: <play name>
    hosts: <hosts>
    tasks:
        - 
            name: <task name>
            <module>:
                <key>: <value>
            register: <var>
```

### Loop
```yaml
-
    name: <play name>
    hosts: <hosts>
    tasks:
        - 
            name: <task name>
            <module>:
                <key>: '{{ item }}'
            loop:
                - foo
                - bar
                - baz
        - 
            name: <task name>
            <module>:
                <name>: '{{ item.name }}'
                <id>: '{{ item.id }}'
            loop:
                - name: foo
                  id: 0001
                - name: bar
                  id: 0002
                - name: baz
                  id: 0003
```

```yaml
-
    name: <play name>
    hosts: <hosts>
    vars:
        <name>
            - <value>
    tasks:
        - 
            name: <task name>
            <module>:
                <key>: '{{ item }}'
            with_items: '{{ <name> }}'
```

`with_*` use plugins to connect / access different resource
Examples:
- with_items
- with_file
- with_url
- with_k8s

## Roles
Roles are used to make work re-usable & best practices.
```yaml
-
    name: <play name>
    hosts: <hosts>
    roles:
        - <role>
```
Will look under the `./roles` folder or the `/etc/ansible/roles`. (defined in ansible.cfg)


All tasks go in the `tasks` directory, same for
- vars
- defaults
- handlers
- templates

Find public roles in [ansible galexy](https://galaxy.ansible.com/)

### Init Role
```bash
ansible-galexy init <name>
```
Will create your own role template.

### Using
```bash
ansible-galaxy install <role-name>
```
Download from ansible-galexy & install to default path.

## Developing Modules
Scripts can be created, put them in your modules folder
[Ansible Documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html)

