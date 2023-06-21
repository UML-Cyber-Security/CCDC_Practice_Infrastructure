# PFSense <!-- omit from toc -->

# Table of Contents <!-- omit from toc -->


## DNS Notes
If we have set the Domain name (System -> General) to be the same used in all the hostnames in the subnets managed by the device, we will be able to use the local DNS server on the **internal interface** of the PFSense router to resolve the local machines. This is only stored on the local DNS so we would need to optionally direct to that.

Probably going us a combination of local DNS resolution and Port Forwarding or Virtual IPs to forward the traffic correctly.
## Exposing Services

### NAT - Port Forwarding 

### Virtual Addresses

