| **Port** | **Service** | **Status** |
| --- | --- | --- |
|   50, 500, 4500 UDP  |  IPSEC   |  Block unless using ipsec within the domain   |
|  53 UDP   |  DNS  |    |
|  67 UDP   |  DHCP   |  If server is used for DHCP, do not block   |
|   135, 593 TCP/UDP  |  RPC   |   If domain-connected, restrict to local DC. If on the DC or cert authority, allow local networks. Otherwise, block.  |
|  137, 138, 139 TCP/UDP   |   Netbios  |   Not necessary in 2019, block access  |
|   389, 636 TCP  |   LDAP  |   Necessary on DC  |
|   3389 TCP  |   RDP  |  If RDP is necessary for local management but not for scoring, restrict to local network.   |
|   5985, 5986 TCP  |   Windows Remote Management  |   Best to ignore these, if they are present than you will break stuff by blocking them  |
|     |     |     |