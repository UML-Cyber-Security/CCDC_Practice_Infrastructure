## Deployments
- Deploy Gitlab + Redis backend + CICD Part of it
- Deploy Vault
- Deploy Prometheus and Grafana
- Deploy Semaphore

## Integrations
- Cert-manager pull certs from Vault acting as CA
- Integrate Vault with #everything
- Semaphore CI/CD with Gitlab

## General 
- Securing the cluster etc
- Monitoring Solution (Ports, new stuff changed, etc)
- Handling Migrations

## For kubernetes redeploy

**Needed**

- Use flannel for CNI
- Need some storage provisioning, preferebly NFS as we need to be able to make pvc claims for databases.
- postgressql-ha -> pvc
- gitlab redis -> pvc
- gitlab webservice

**Potential**

- HAProxy
- Nginx
- GitLab
- PostgreSQL
- Semaphore
- Nextcloud
- vault