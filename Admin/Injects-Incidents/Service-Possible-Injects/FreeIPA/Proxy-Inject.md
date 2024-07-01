# FreeIPA
FreeIPA is an identity management system that allows users to authenticate as a user before they try to gain access to materials that they are cleared to have access to. This is a critical portion of the infrastructure because without it there can be no login process.

**Time**: 30min (Contains the estimated time of competition)

## Expectations 
What should be implemented and completed by the time this inject is completed 
1. The static IP and DNS hostname of FreeIPA should be known to the proxy
2. An IPtable or fo=irewall rule must be added to redirect traffic to the right machine.

Link: https://www.adelton.com/freeipa/freeipa-behind-proxy-with-different-name 

## Dependencies
The IP and DNS entry for FreeIPA should stay satic for the entirity of its lifetime.

## Inject
We don't want identity management open to the public internet. Fix that without limiting access.