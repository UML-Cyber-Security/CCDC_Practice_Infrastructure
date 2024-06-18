# k8s Setup

Setup a k8s demo cluster.

Note:
- Requires at least 2 vCPU

## Run the following commands in order
Replace USER and KEY with the initial info
```bash
ansible-playbook users.yaml --user=USER --private-key=KEY

ansible-playbook --private-key=./keys/id_rsa install-k8s.yaml

ansible-playbook --private-key=./keys/id_rsa master.yaml

ansible-playbook --private-key=./keys/id_rsa join-workers.yaml
```

## Connecting to master node
```bash
ssh -i ./keys/id_rsa kube@$(ansible-inventory --host master01 | jq -r .ansible_host)
```

## Static files

Store static files in `/k8s/`.

[Source](https://buildvirtual.net/deploy-a-kubernetes-cluster-using-ansible/)