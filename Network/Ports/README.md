# Ports  <!-- omit from toc -->
This document will be a set of **tables** that specify the *ports* and *transport* layer protocols used by each application that we are concerned with.

## Table Of Contents  <!-- omit from toc -->
- [App Ports](#app-ports)
  - [Template](#template)
  - [SSH](#ssh)
    - [Server](#server)
    - [Client](#client)
  - [RDP](#rdp)
    - [Client](#client-1)
    - [Server](#server-1)
  - [HTTP](#http)
    - [Server](#server-2)
    - [Client](#client-2)
  - [HTTPS](#https)
    - [Server](#server-3)
      - [Client](#client-3)
  - [DNS](#dns)
  - [Teleport](#teleport)
    - [User Client](#user-client)
    - [Teleport Agent Client](#teleport-agent-client)
    - [Server](#server-4)
- [Firewall Considerations](#firewall-considerations)
- [Firewall](#firewall)
  - [Template](#template-1)
    - [Host Inbound](#host-inbound)
    - [Host Outbound](#host-outbound)
    - [Network Inbound](#network-inbound)
    - [Network Outbound](#network-outbound)
  - [SSH Server](#ssh-server)
    - [Host Inbound](#host-inbound-1)
    - [Host Outbound](#host-outbound-1)
    - [Network Inbound](#network-inbound-1)
    - [Network Outbound](#network-outbound-1)
  - [SSH Client](#ssh-client)
    - [Host Inbound](#host-inbound-2)
    - [Host Outbound](#host-outbound-2)
    - [Network Inbound](#network-inbound-2)
    - [Network Outbound](#network-outbound-2)
  - [Teleport](#teleport-1)
    - [Host Inbound](#host-inbound-3)
    - [Host Outbound](#host-outbound-3)
    - [Network Inbound](#network-inbound-3)
    - [Network Outbound](#network-outbound-3)


## App Ports
The following are ports that each application uses. These can be a single well known port, or a range of ports as is common when creating requests. 

We specify the port, if it is for inbound or outbound traffic, and what type of Transport layer traffic is generated. An affirmative will be signaled by a check mark (<span>&#10004;</span>).
### Template 
Use ```<span>&#10004;</span>``` to produce a <span>&#10004;</span>. The following table should be used.

|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
| | | | | | 
### SSH 
#### Server
|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
| 22 | <span>&#10004;</span> | <span>&#10004;</span> |<span>&#10004;</span>| | 

#### Client
|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
|1024 - 65535 | | <span>&#10004;</span> | <span>&#10004;</span> | |
**Note**: A server will respond to requests on port 22

### RDP 
#### Client
#### Server

### HTTP
#### Server
|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
| 80 | <span>&#10004;</span> | <span>&#10004;</span> | <span>&#10004;</span> | |

#### Client
|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
|1024 - 65535 | | <span>&#10004;</span> | <span>&#10004;</span> | |
**Note**: A server will respond to requests on port 80
### HTTPS
#### Server
|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
| 443 | <span>&#10004;</span> | <span>&#10004;</span>  | <span>&#10004;</span> | |
##### Client
|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
|1024 - 65535 | | <span>&#10004;</span> | <span>&#10004;</span> | |
**Note**: A server will respond to requests on port 443
### DNS 
|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
| 53 | <span>&#10004;</span> | <span>&#10004;</span> | <span>&#10004;</span> | <span>&#10004;</span> | 
**Note**: UDP is the default, TCP is a fallback. The Client and Server communicate using port 53.

### Teleport
*Ref*: https://goteleport.com/docs/reference/networking/
#### User Client
We are using the HTTPS Client...

|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
| 443 | <span>&#10004;</span> | <span>&#10004;</span>  | <span>&#10004;</span> | |

#### Teleport Agent Client
This is the service installed on the machines we are using teleport to connect to.
|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
| 443 | <span>&#10004;</span> | <span>&#10004;</span>  | <span>&#10004;</span> | |
| 3021 | <span>&#10004;</span> | <span>&#10004;</span>  | <span>&#10004;</span> | |
**Note**: We can configure Teleport to use different Ports in the Config. 
#### Server
|Port| Inbound | Outbound | TCP | UDP |
|-|-|-|-|-| 
| 443 | <span>&#10004;</span> | <span>&#10004;</span>  | <span>&#10004;</span> | |
| 3021 | <span>&#10004;</span> | <span>&#10004;</span>  | <span>&#10004;</span> | |

## Firewall Considerations
Primarily, we should always use a **deny by default** scheme where entries preform like a *whitelist* rather than a *blacklist*. This is for a few reasons, first its more likely that in the list of around 65 thousand ports, we are going to block manna more than we allow.  The second is any ports that we may forget to block, or restrict will be blocked by default, this may cause issues with uptime; but in the case of a CCDC it is the much safer option which should easily be fixed. 

## Firewall
This section contains the programs, and protocols that should be allowed when the applications are used. If they are not used in an infrastructure, there is no reason that they should be used. 


Each table will consist of a set of ports, if the port is a source or destination port, and whether TCP, UDP or both should be allowed. An affirmative will be signaled by a check mark (<span>&#10004;</span>). 

The sections **Host** and **Network** refer to the Host Based firewall and network firewall respectively. Each has an inbound and outbound table.

### Template 
Use ```<span>&#10004;</span>``` to produce a <span>&#10004;</span>
#### Host Inbound
|Port| Source | Destination | TCP | UDP |
|-|-|-|-|-| 
| | | | | | 
#### Host Outbound
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| | | | | | 

#### Network Inbound 
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| | | | | | 
#### Network Outbound
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| | | | | | 
### SSH Server
These are the Ports used by 
#### Host Inbound
|Port| Source | Destination | TCP | UDP |
|-|-|-|-|-| 
| 22 | | <span>&#10004;</span> | <span>&#10004;</span> | | 
#### Host Outbound
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| 22 | | <span>&#10004;</span> | <span>&#10004;</span> | | 

#### Network Inbound 
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| 22 | | <span>&#10004;</span> | <span>&#10004;</span> | | 
#### Network Outbound
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| 22 | <span>&#10004;</span> | | <span>&#10004;</span> | | 
### SSH Client
#### Host Inbound
**Note**: Rely on the stateful nature of the firewall allowing the response through
#### Host Outbound
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| 22 | | <span>&#10004;</span> | <span>&#10004;</span> | | 

#### Network Inbound 
**Note**: Rely on the stateful nature of the firewall allowing the response through
#### Network Outbound
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| 22 | | <span>&#10004;</span> | <span>&#10004;</span> | | 

### Teleport
#### Host Inbound
|Port| Source | Destination | TCP | UDP |
|-|-|-|-|-| 
| | | | | | 
#### Host Outbound
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| | | | | | 

#### Network Inbound 
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| | | | | | 
#### Network Outbound
|Port| Source | Destination | TCP | UDP | 
|-|-|-|-|-| 
| | | | | | 