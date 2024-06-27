# List of Ports Used by Ubuntu Machines  <!-- omit-from-toc --> <!-- omit in toc -->
- [UbuntuMachine1](#ubuntumachine1)
- [UbuntuMachine2](#ubuntumachine2)
- [UbuntuMachine3](#ubuntumachine3)
- [UbuntuManager](#ubuntumanager)
- [Reference table:](#reference-table)

## UbuntuMachine1
-----------------------------------------------
| Machine       | Proto | Local Address       | Foreign Address  | State  | PID/Program name       |
|---------------|-------|---------------------|------------------|--------|------------------------|
| UbuntuMachine1| tcp   | 127.0.0.1:**631**   | 0.0.0.0:*        | LISTEN | 521928/cupsd           |
| UbuntuMachine1| tcp   | 127.0.0.53:**53**   | 0.0.0.0:*        | LISTEN | 440/systemd-resolve    |
| UbuntuMachine1| tcp   | 0.0.0.0:**22**     | 0.0.0.0:*        | LISTEN | 30544/sshd: /usr/sb   |
| UbuntuMachine1| tcp6  | ::1:**631**         | :::*             | LISTEN | 521928/cupsd           |
| UbuntuMachine1| tcp6  | :::7946            | :::*             | LISTEN | 46480/dockerd          |
| UbuntuMachine1| tcp6  | :::22              | :::*             | LISTEN | 30544/sshd: /usr/sb   |
| UbuntuMachine1| tcp6  | :::81              | :::*             | LISTEN | 46480/dockerd          |
| UbuntuMachine1| udp   | 0.0.0.0:**631**     | 0.0.0.0:*        |        | 521929/cups-browsed    |
| UbuntuMachine1| udp   | 0.0.0.0:**39593**   | 0.0.0.0:*        |        | 466/avahi-daemon: r    |
| UbuntuMachine1| udp   | 0.0.0.0:**4789**    | 0.0.0.0:*        |        | -                      |
| UbuntuMachine1| udp   | 0.0.0.0:**5353**    | 0.0.0.0:*        |        | 466/avahi-daemon: r    |
| UbuntuMachine1| udp   | 127.0.0.53:**53**   | 0.0.0.0:*        |        | 440/systemd-resolve   |
| UbuntuMachine1| udp6  | :::60044           | :::*             |        | 466/avahi-daemon: r    |
| UbuntuMachine1| udp6  | :::5353            | :::*             |        | 466/avahi-daemon: r    |
| UbuntuMachine1| udp6  | :::7946            | :::*             |        | 46480/dockerd          |




## UbuntuMachine2
----------------------------------
| Machine       | Proto | Port              | Foreign Address  | State  | PID/Program name       |
|---------------|-------|-------------------|------------------|--------|------------------------|
| UbuntuMachine2| tcp   | 0.0.0.0:**22**    | 0.0.0.0:*        | LISTEN | 30804/sshd: /usr/sb    |
| UbuntuMachine2| tcp   | 127.0.0.1:**631** | 0.0.0.0:*        | LISTEN | 526363/cupsd           |
| UbuntuMachine2| tcp   | 127.0.0.53:**53** | 0.0.0.0:*        | LISTEN | 396/systemd-resolve    |
| UbuntuMachine2| tcp6  | :::**81**         | :::*             | LISTEN | 692/dockerd            |
| UbuntuMachine2| tcp6  | :::**22**         | :::*             | LISTEN | 30804/sshd: /usr/sb    |
| UbuntuMachine2| tcp6  | ::1:**631**       | :::*             | LISTEN | 526363/cupsd           |
| UbuntuMachine2| tcp6  | :::**7946**       | :::*             | LISTEN | 692/dockerd            |
| UbuntuMachine2| udp   | 127.0.0.53:**53** | 0.0.0.0:*        |        | 396/systemd-resolve    |
| UbuntuMachine2| udp   | 0.0.0.0:**631**   | 0.0.0.0:*        |        | 526364/cups-browsed    |
| UbuntuMachine2| udp   | 0.0.0.0:**4789**  | 0.0.0.0:*        |        | -                      |
| UbuntuMachine2| udp   | 0.0.0.0:**38012** | 0.0.0.0:*        |        | 465/avahi-daemon: r    |
| UbuntuMachine2| udp   | 0.0.0.0:**5353**  | 0.0.0.0:*        |        | 465/avahi-daemon: r    |
| UbuntuMachine2| udp6  | :::**7946**       | :::*             |        | 692/dockerd            |
| UbuntuMachine2| udp6  | :::**42957**      | :::*             |        | 465/avahi-daemon: r    |
| UbuntuMachine2| udp6  | :::**5353**       | :::*             |        | 465/avahi-daemon: r    |


## UbuntuMachine3
----------------------------------------------
| Machine        | Proto | Port            | Foreign Address  | State  | PID/Program name       |
|----------------|-------|-----------------|------------------|--------|------------------------|
| UbuntuMachine3 | tcp   | 127.0.0.53:**53** | 0.0.0.0:*        | LISTEN | 416/systemd-resolve   |
| UbuntuMachine3 | tcp   | 127.0.0.1:**631** | 0.0.0.0:*        | LISTEN | 523140/cupsd           |
| UbuntuMachine3 | tcp   | 0.0.0.0:**22**   | 0.0.0.0:*        | LISTEN | 22502/sshd: /usr/sb   |
| UbuntuMachine3 | tcp6  | :::7946         | :::*             | LISTEN | 688/dockerd            |
| UbuntuMachine3 | tcp6  | ::1:**631**      | :::*             | LISTEN | 523140/cupsd           |
| UbuntuMachine3 | tcp6  | :::81           | :::*             | LISTEN | 688/dockerd            |
| UbuntuMachine3 | tcp6  | :::22           | :::*             | LISTEN | 22502/sshd: /usr/sb   |
| UbuntuMachine3 | udp   | 127.0.0.53:**53** | 0.0.0.0:*        |        | 416/systemd-resolve   |
| UbuntuMachine3 | udp   | 0.0.0.0:**631**   | 0.0.0.0:*        |        | 523141/cups-browsed    |
| UbuntuMachine3 | udp   | 0.0.0.0:**4789**  | 0.0.0.0:*        |        | -                      |
| UbuntuMachine3 | udp   | 0.0.0.0:**54279** | 0.0.0.0:*        |        | 465/avahi-daemon: r    |
| UbuntuMachine3 | udp   | 0.0.0.0:**5353**  | 0.0.0.0:*        |        | 465/avahi-daemon: r    |
| UbuntuMachine3 | udp6  | :::7946         | :::*             |        | 688/dockerd            |
| UbuntuMachine3 | udp6  | :::60255        | :::*             |        | 465/avahi-daemon: r    |
| UbuntuMachine3 | udp6  | :::5353         | :::*             |        | 465/avahi-daemon: r    |


## UbuntuManager
----------------------------------------------------
| Machine       | Proto | Local Address     | Foreign Address  | State  | PID/Program name     |
|---------------|-------|-------------------|------------------|--------|----------------------|
| UbuntuManager | tcp   | 127.0.0.53:**53** | 0.0.0.0:*        | LISTEN | 415/systemd-resolve  |
| UbuntuManager | tcp   | 127.0.0.1:**631** | 0.0.0.0:*        | LISTEN | 785423/cupsd         |
| UbuntuManager | tcp   | 0.0.0.0:**22**   | 0.0.0.0:*        | LISTEN | 189960/sshd: /usr/s   |
| UbuntuManager | tcp   | 0.0.0.0:**80**   | 0.0.0.0:*        | LISTEN | 295037/docker-proxy   |
| UbuntuManager | tcp   | 0.0.0.0:**81**   | 0.0.0.0:*        | LISTEN | 301337/docker-proxy   |
| UbuntuManager | tcp6  | :::**7946**      | :::*             | LISTEN | 683/dockerd           |
| UbuntuManager | tcp6  | ::1:**631**      | :::*             | LISTEN | 785423/cupsd          |
| UbuntuManager | tcp6  | :::**2377**      | :::*             | LISTEN | 683/dockerd           |
| UbuntuManager | tcp6  | :::**22**        | :::*             | LISTEN | 189960/sshd: /usr/s   |
| UbuntuManager | tcp6  | :::**80**        | :::*             | LISTEN | 295042/docker-proxy   |
| UbuntuManager | tcp6  | :::**81**        | :::*             | LISTEN | 301342/docker-proxy   |
| UbuntuManager | udp   | 127.0.0.53:**53**| 0.0.0.0:*        |        | 415/systemd-resolve   |
| UbuntuManager | udp   | 0.0.0.0:**60009**| 0.0.0.0:*        |        | 464/avahi-daemon:     |
| UbuntuManager | udp   | 0.0.0.0:**631**  | 0.0.0.0:*        |        | 785424/cups-browsed   |
| UbuntuManager | udp   | 0.0.0.0:**4789** | 0.0.0.0:*        |        | -                     |
| UbuntuManager | udp   | 0.0.0.0:**5353** | 0.0.0.0:*        |        | 464/avahi-daemon:     |
| UbuntuManager | udp6  | :::**7946**      | :::*             |        | 683/dockerd           |
| UbuntuManager | udp6  | :::**59528**     | :::*             |        | 464/avahi-daemon:     |
| UbuntuManager | udp6  | :::**5353**      | :::*             |        | 464/avahi-daemon:     |




## Reference table:

avahi-demon - Tells devices which devices are what based on their local ip address. Also is in charge of connecting local Ip adressess to services on the machine, somewhat similar to a local DNS.

systemd-resolve  Linux System manager 

sshd: /usr/s - ssh Server

cupsd - Linux printing system

0.0.0.0:* - Emoji - means no associated address - I am not correcting this... sue me.

Note -  These are all internal services which do not "speak" to the outside world, hence, no foreign addresses.