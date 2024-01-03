# Goal

This is very high-level description of the steps needed to get `nxlog` on Windows to send logs to a `syslog-ng` server over a TLS connection.


# Steps

1. Download and install `nxlog` using the URL - https://nxlog.co/system/files/products/files/348/nxlog-ce-2.10.2150.msi

2. Edit the `nxlog.conf` file located inside `C:\Program Files (x86)\nxlog\conf\` and add / update the following code blocks -

```
    <Extension _syslog>
        Module          xm_syslog
    </Extension>

    <Input s_events>
        Module          im_msvistalog
    </Input>

    <Output d_remote>
        Module          om_ssl
        Host            <server_ip_address>
        Port            6514
        CAFile          <ca_file_path>
        CertFile        <client_cert_path>
        CertKeyFile     <client_key_path>
        Exec    	to_syslog_ietf();
    </Output>

    <Route eventlog_to_tcp>
        Path    	s_events => d_remote
    </Route>
```

3. As an administrator, run the following commands on a command prompt.

```
    > net stop nxlog

    > net start nxlog
```
