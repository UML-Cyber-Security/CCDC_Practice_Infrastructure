## Storage
This is the physical backend that Vault uses for storage. 
- Dev server uses "inmem" (in memory),
- Integrated Storage (raft), a much more production-ready backend.
- For our purpose we will be using integrated storage
  
storage "raft" {
  path = "/path/to/raft/data"
  node_id = "raft_node_1"
}
cluster_addr = "http://127.0.0.1:8201"

## Listener
Defines on what ports vault is waiting for incoming connections
In our case the raft storage represents an internal storage, so our IP and port are internally based.

listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 0 #Enables HTTPS
  tls_cert_file = ...  # certifcation file.pem - Place the full path where it is saved on the machine
  tls_key_file = ...  # certifcation file_private_key.pem - Place the full path where it is saved on the machine
}

ui = true #Enables browser interface