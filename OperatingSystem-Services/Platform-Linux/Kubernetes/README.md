# Current Kubernetes Infastructure


## IPS / Domains

[hosts]
- k8-master-1
  - 192.168.3.200
- k8-worker-1
  - 192.168.3.210
- k8-worker-2
  - 192.168.3.211
- k8-worker-3
  - 192.168.3.212

[network]
- k8 subnet
  - 10.90.0.0/16
- metallb balancer range
  - 192.168.3.220-192.168.3.230

## Core Services / Plugins

- Ingress
  - [nginx-ingress-controller](https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-helm/)
- Loadbalancer
  - [metallb](https://metallb.org/installation/)
- CNI
  - [flannel](https://github.com/flannel-io/flannel)
- CSI
  - [csi-driver-nfs](https://github.com/kubernetes-csi/csi-driver-nfs/tree/master/charts)


## Deployed Applications

- Vault
  - http://192.168.3.220:8200/ui/vault/dashboard


## TODO

### Deployments
- ~~postgressql-ha~~
- ~~Deploy Gitlab + Redis backend~~
- ~~Gitlab webservice~~
- ~~Deploy Vault~~
- ~~Deploy Prometheus and Grafana~~
- Deploy Semaphore

### Integrations
- Cert-manager pull certs from Vault acting as CA
- Integrate Vault with #everything
- Semaphore CI/CD with Gitlab

### General 
- Securing the cluster etc
- Monitoring Solution (Ports, new stuff changed, etc)
- Handling Migrations

### Side info from packets

**Needed**

- ~~Use flannel for CNI~~
- ~~Need some storage provisioning, preferebly NFS as we need to be able to make pvc claims for databases.~~


**Potential**

- HAProxy
- Nginx
- GitLab
- PostgreSQL
- Semaphore
- Nextcloud
- vault