# Linux Static IP Configurations <!-- omit in toc -->
Initially Written by Matt Harper (Sad).

---
- [IP Addresses](#ip-addresses)
  - [Redhat Systems](#redhat-systems)
  - [Debian Systems](#debian-systems)
- [Interface Manipulation](#interface-manipulation)


## IP Addresses
This is a section that pertains to the setting, and modification of **static** (manually) configured IP addresses.
This is not a comprehensive document as to why or when you should do this, simply how it can be done on a given
*Linux* system. Please refer to the Windows documentation for how it can be done on a Windows Server machine.

### Redhat Systems
This section covers a method we can use to manually configure the IP assigned to a redhat Linux machine. As they
often utilize [NetworkManager](https://wiki.archlinux.org/title/NetworkManager) you can use the *Terminal User Interface*
(TUI) program [nmtui](https://networkmanager.dev/docs/api/latest/nmtui.html), or you can use the CLI interface
[nmcli](https://networkmanager.dev/docs/api/latest/nmcli.html).

**NMTUI**:
1. Run `nmtui` as a sudo user.
  ```
  $ sudo nmtui
  ```
2. Select *Edit a connection*, and hit enter. You can navigate with the *arrow keys*.

  ![Alt text](Images/NMTUI-1.png)

3. Select the network interface you would like to edit and hit enter.

  ![Alt text](Images/NMTUI-2.png)

4. Move down to thew IPv4 configuration. Select Manual configuration.

  ![Alt text](Images/NMTUI-3.png)

5. Move over to *Show* and hit enter.

  ![Alt text](Images/NMTUI-4.png)

1. Click *add* and fill out the information.

  ![Alt text](Images/NMTUI-5.png)

  * You can find out the default gateway by using the command `ip r`. This is only useful if we are configuring the public interfaces as static, at which point we need to know the gateway for the *private* network we are created the subnet in.

7. Click **OK**.

  ![Alt text](Images/NMTUI-6.png)

8. Select **Back**.

  ![Alt text](Images/NMTUI-7.png)

9. Select **Quit**.

  ![Alt text](Images/NMTUI-8.png)

10. Restart network manager
  * Restart service.
    ```
    # Ubuntu
      sudo systemctl restart network-manager

    # RHEL
      sudo systemctl restart NetworkManager
    ```
  * Restart the machine.
    ```
      sudo restart
    ```
**NMCLI**
1. Open a terminal on the target machine.
2. Run `systemctl status NetworkManager` to ensure the network management service is running.
3. Run `ip a` or `ip a show` to display the current interface configurations, they should be *manual* (static) or *DHCP*.
4. Run the following series of commands to statically configure the IP of the machine, this show the `ens3` interface being modified, this can be changed to any valid interface on your device.
   1. `nmcli con mod ens3 ipv4.addresses <CIDR-IP>`
      * Modify the `ens3` interface to have the specified IP address.
   2. `nmcli con mod ens3 ipv4.gateway <Gateway-IP>`
      * Modify the `ens3` interface to have the specified gateway (Where it directs external bound traffic).
   3. `nmcli con mod ens3 ipv4.method manual`
      * Modify `ens3` to be static (not use DHCP).
   4. `nmcli con mod ens3 ipv4.dns "<DNS-Server>"`
      * Modify `ens3` to use the specified DNS server.
   5. `nmcli con up ens3`
      * Bring interface up
5. We can look at the updated configuration using the following command ```cat /etc/sysconfig/network-scripts/ifcfg-ens3```
6. Stop DHCP services `sudo systemctl stop dhcpd`



**Proven Manual Method**
1. Open a file `vim /etc/sysconfig/network-scripts/ifcfg-ens19`
2. Add in the following information Replace anything in `<...>` with the desired values:
  ```
  TYPE="Ethernet"
  BOOTPROTO="none"
  IPADDR="<IP>"
  NETMASK="<MASK i.e 255.255.255.0>"
  GATEWAY="<IP>"
  DEVICE="<DEV NAME i.e ens19>"
  NAME="<DEV NAME i.e ens19>"
  ONBOOT="yes"
  DNS1="<IP>"
  ```
3. Reboot and run nmtui on the device (Ensures it is configured)
  ```
  nmtui edit <dev>
  ```
4. This will result in a similar configuration to the following
  ![Alt text](Images/RH1.png)

### Debian Systems

> [!NOTE]
> You should make a new file for each of the interfaces you wish to modify or statically configure. You should also remove any additional references to the interface from other configuration files.

1. Open a terminal on the target machine
2. navigate to the `/etc/netplan/` directory
    ```
    cd /etc/netplan/
    ```
   * There will be a file `00-installer...`, you
3. Create the following file
    ```
    sudo vim /etc/netplan/01-netplan.yaml
    ```
   * Using vim makes *Alex* happy. Can anything?.
   * Must be a yaml file **with** the `.yaml` extension, `.yml` is ignored.
   * The number at the front determines it's priority. Earlier settings are more like *defaults* they are applied to the netplan files with higher numbers unless their configs are overwritten. (`01-netplan.yaml` would set a default *renderer* that can be overwritten by later configurations like `67-internal.yaml`).
4. Add the following boilerplate to each of the files.
    ```
    network:
      version: 2
    ```
    * We are using version 2, this is the only supported version.
5. (Optional) Add rendered as NetworkManager.
    ```
    network:
      version: 2
      renderer: NetworkManager
    ```
    * This*renderer* option means rather than being rendered by `systemd-networkd`, it will be rendered by NetworkManger, which allows you to use the aforementioned `nmxxx` commands. Valid options are *networkd* and *NetworkManager*
6. Add a ethernet section (Use the name of the physical interface oberserved with `ip l`) , and interface. We are doing this going to be a manually configured interface, so we do not need *dhcp*.
    ```
    network:
      version: 2
      renderer: NetworkManager
      ethernets:
          eth0:
          dhcp4: no
    ```
    * We can also disable *IPv6* `dhcp6: no` similar to how IPv4 was disabled.
7. Configure the interface with a gateway and Static IP
    ```
    network:
      version: 2
      renderer: NetworkManager
      ethernets:
          eth0:
          dhcp4: no
          addresses: [<Static-IP>]
          routes:
            - to: default
              via: <IP>
    ```
    * The deprecated `gateway4: IP` can also be used but the provided *routes* is preferred, it also allows us to set up multiple routes to various subnets.
8. Configure DNS
    ```
    network:
      version: 2
      renderer: NetworkManager
      ethernets:
          eth0:
          dhcp4: no
          addresses: [<Static-IP>]
          routes:
            - to: default
              via: <IP>
          nameservers:
            addresses: [<IP>,<IP>]
    ```
    * You should specify one or more nameservers, common ones include `8.8.8.8` (Google DNS) and `1.1.1.1` (Cloudflare)
9. Run `sudo netplan try`
   * This will apply the changes temporarily, you must run another command in order to make this permanent.
10. Run `sudo netplan apply` in order to make this change permian
> [!IMPORTANT]
> The netplan files need to be owned by root `chown root:root /etc/netplan/<FILE` and they need to be readable and writable by the owner (root) only: `chmod 0600 /etc/netplan/<FILE`

For example the following is one we have used on an ubuntu machine in the past:
```
network:
  ethernets:
    ens19:
    dhcp4: false
    addresses: [10.0.2.10/24]
    routes:
      - to: default
        via: 10.0.2.1
    nameservers:
      addresses: [8.8.8.8]
  version: 2
```
## Interface Manipulation

1. Bring down a specified interface.
  ```
  sudo ip link set dev <interface> down
  ```
2. Bring the specified interface back up.
  ```
  sudo ip link set dev <interface> up
  ```