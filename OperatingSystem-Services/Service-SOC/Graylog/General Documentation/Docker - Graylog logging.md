# DOCKER Graylog Logging #


Short writeup showing the basics of adding logging inputs (Linux and Windows) to a Graylog manager.  
For this setup, the manager is on a Ubuntu system through Docker.  


## 1. Check your Ports ##

Check the ports that are used for all your logging inputs.  
This can be done in the docker-compose file.  

SAMPLE snippet of a compose.yaml file.  
```yaml
ports:
      # Graylog web interface and REST API
      - "9000:9000/tcp"
      # Beats inputs ()
      - "5044:5044/tcp"
      # Syslog TCP (rsyslog and others)
      - "5140:5140/tcp"
      # Syslog UDP (rsyslog and others)
      - "5140:5140/udp"
      # GELF TCP (some smart logging)
      - "12201:12201/tcp"
      # GELF UDP (some smart logging)
      - "12201:12201/udp"
      # Forwarder data
      - "13301:13301/tcp"
      # Forwarder config
      - "13302:13302/tcp"
    restart: "on-failure"
```

## Graylog Sidecar ##

Graylog Sidecar -> configuration management system for log collectors.  
This is available to both Windows and Linux, and works through Graylogs API to enable, configure, and collect logs from machines.  
This is slightly similar to a Wazuh "agent", but the key difference is that Sidecar itself is NOT a log collector, just a manager.  


## 3. Adding rsyslog logging (Linux) ##

For the "agent" machine, adding the following to the bottom of the ```/etc/rsyslog.conf``` or any other rsyslog configuration files will add rsyslog logging.<br><br>

Make sure the correct port is set. (Our example port above shows syslog as port 5140).  
For TCP logging
```*.*@@<Graylog_ip>:<port>;RSYSLOG_SyslogProtocol23Format" >> "/etc/rsyslog.conf``` <br>
or  
For UDP logging
```*.*@<Graylog_ip>:<port>;RSYSLOG_SyslogProtocol23Format" >> "/etc/rsyslog.conf```

## Adding Eventlog logging (NXLog + GELF) (Windows)

## 3.1 Adding Eventlog logging (Sidecar + Winlogbeat) (Windows)

Easiest way to add this is to download Graylog Sidecar (configuration management system for log collectors) onto each Windows machine that needs logging.  

Sidecar uses Graylogs REST API, so this needs to be secured.  

Sidecar can then configure either NXLog logging or (recommended) Winlogbeat.


## 4. Adding Palo Al ##

## 5. Adding pfSense ##
Working extractor ruleset: https://github.com/xTITUSMAXIMUSX/graylog-pfsense 
