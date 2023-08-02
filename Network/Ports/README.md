# Ports <!-- omit from toc -->
This document will be a set of **tables** that specify the *ports* and *transport* layer protocols used by each application that we are concerned with.

## Table Of Contents <!-- omit from toc -->
- [Used](#used)
- [To Block](#to-block)

## Firewall Considerations
Primarily, we should always use a **deny by default** scheme where entries preform like a *whitelist* rather than a *blacklist*. This is for a few reasons, first its more likely that in the list of around 65 thousand ports, we are going to block manna more than we allow.  The second is any ports that we may forget to block, or restrict will be blocked by default, this may cause issues with uptime; but in the case of a CCDC it is the much safer option which should easily be fixed. 

## Used
This section contains the programs, and protocols that should be allowed when the applications are used. If they are not used in an infrastructure, there is no reason that they should be used.
 
