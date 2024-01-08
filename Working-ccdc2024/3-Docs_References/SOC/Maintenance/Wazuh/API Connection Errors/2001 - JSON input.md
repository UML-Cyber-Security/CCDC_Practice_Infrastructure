# Wazuh Dashboard Error 2001 - JSON input

**Summary:**
This error is likely caused by a misconfiguration or some exception that was caused by a corrupted file. The soltuion is to stop the dashboard, delete a file and then restart the dashboard. 


## Initial Information
When you first log into the Wazuh Dashboard, then you will see an API error that has the error message *"wazuh error connecting to api: 2001 - unexpected end of json input"*

Solution steps is [here](https://groups.google.com/g/wazuh/c/UvSAcxBzloY)


## Steps

1. Stop the Wazuh dashboard
```
    sudo systemctl stop wazuh-dashboard
```


2. Remove the wazuh-registry.json file

```
    rm /usr/share/wazuh-dashboard/data/wazuh/config/wazuh-registry.json
```

3. Restart the Wazuh Dashboard

```
    sudo systemctl start wazuh-dashboard
```

