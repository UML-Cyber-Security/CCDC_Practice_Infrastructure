# Graylog TLS Setup #
WHAT THIS IS:  
Guide showing on how to setup https and TLS on Graylog.


## 1. Generate .csr and give to CA ##
Make sure openssl is installed.  
Generate the .csr file with the following command:  
```bash
openssl req -newkey rsa:2048 -keyout PRIVATEKEY.key -out YOURDOMAIN.csr
```

Save the `PRIVATE.key` file, and give the `YOURDOMAIN.csr` to the CA. 

## 2. Create the .PEM files ##
Use the following commands  
```bash
openssl x509 -inform DER -in YOURDOMAIN.cer -out graylog-certificate.pem
```

## 3. Combine the cert with the Root cert (Optional)

If CA root file is also provided, you can combine the two certs:  
```bash
cat graylog-certificate.pem INTERMEDIATE-CA.crt ROOT-CA.crt > fullchain.pem
```

## 4. Edit the Graylog config file ##
Edit the /etc/graylog/server/server.conf file to change the following:  

```
http_enable_tls -> true

http_tls_cert_file -> Set to the .PEM chain file

http_tls_key_file -> private key in .PEM format

http_tls_key_password -> password to unlock the privateKey (Only if password was made!)
```

