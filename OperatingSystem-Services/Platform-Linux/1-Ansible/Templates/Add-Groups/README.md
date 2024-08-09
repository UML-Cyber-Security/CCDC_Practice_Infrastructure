
    - name: Group-Creation
      ansible.builtin.group:
        name: Minecraft-User
        state: present

    - name: Add-Sudoer-File
      ansible.builtin.lineinfile:
        path: /etc/sudoers
        state: present
        regexp: '^%Minecraft-User'
        line: '%Minecraft-User ALL=(ALL) NOPASSWD: ALL'
        validate: '/usr/sbin/visudo -cf %s'
      become: yes




    # Per the generous chatGPT
    - name: Check if sudo group exists
      command: getent group sudo
      register: sudo_group_result
      ignore_errors: yes

    - name: Check if wheel group exists
      command: getent group wheel
      register: wheel_group_result
      ignore_errors: yes

    - name: Determine target group (sudo)
      set_fact:
        target_group: "{{ 'sudo' }}"
      when: sudo_group_result.rc == 0

    - name: Determine target group (wheel)
      set_fact:
        target_group: "{{ 'wheel' }}"
      when: wheel_group_result.rc == 0 and sudo_group_result.rc != 0

    - name: Determine target (None)
      set_fact:
        target_group: "{{ 'none' }}"
      when: wheel_group_result.rc != 0 and sudo_group_result.rc != 0

    # End GPT Block...
    - name: Fail if no target group found
      fail:
        msg: "Neither sudo nor wheel group exists."
      when: target_group == "none"