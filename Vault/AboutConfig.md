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

## Listner
