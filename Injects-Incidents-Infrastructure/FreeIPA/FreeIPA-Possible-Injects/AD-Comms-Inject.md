# FreeIPA
FreeIPA is an identity management system that allows users to authenticate as a user before they try to gain access to materials that they are cleared to have access to. This is a critical portion of the infrastructure because without it there can be no login process.

**Time**: 1hr (Contains the estimated time of competition)

## Expectations 
What should be implemented and completed by the time this inject is completed 
1. Both FreeIPA and Active Directory must be active
2. Trust must be made between the 2 services using steps in their documentation
3. Communication between the 2 must be spun up and maintained.

Link: https://computingforgeeks.com/establish-trust-between-ipa-and-active-directory/ 

## Dependencies
Active Directory has to be up and running. The hostnames/IPs of both systems cannot change once communication is setup.

## Inject
We don't like having 2 seperate Identity systems, have them work together.