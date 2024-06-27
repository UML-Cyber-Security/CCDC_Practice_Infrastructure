# HAProxy
This is a reverse proxy service that gives access to the internal network services. This is an application and transport layer proxy.

## Dependencies
This service may depend on the Internal DNS services, and the local Firewall's configuration. Of course it is dependent on the Host Linux System.

## First 15
* Create backup of the Proxies configuration
* Ensure the [Stats page](https://www.haproxy.com/blog/exploring-the-haproxy-stats-page) is not accessible
* Update SSL Keys if present
* Configure SSL with Certificate from Windows CA (If set up, and external DNS is used)
  * At least Rotate it
* Add Entries for services if they do not already exist
## First 30
* Create round-robin entries for each service proxied, one with the DNS entry and one with the IP
* Configure SSL with Certificate from Windows CA (If set up, and external DNS is used)


## Stretch Goals
* High Availability?
  * If possible set up an alternate HAProxy service
  * Use DNS to do a poor man's round robin