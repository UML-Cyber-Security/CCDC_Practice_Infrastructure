# Deploying Postgressql

[toc]

## General Information

### Open Ports

Internal:

- 5432

## Known Requirements

- 

## Installation

### First install the operator

Add helm repo

    helm repo add cnpg https://cloudnative-pg.github.io/charts

Install / Upgrade

    helm upgrade --install cnpg \
    --namespace cnpg-system \
    --create-namespace \
    cnpg/cloudnative-pg

### Deploy the postgressql cluster

```yaml
# Example of PostgreSQL cluster
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: gitlab
  namespace: dev
spec:
  instances: 2

  # Example of rolling update strategy:
  # - unsupervised: automated update of the primary once all
  #                 replicas have been upgraded (default)
  # - supervised: requires manual supervision to perform
  #               the switchover of the primary
  primaryUpdateStrategy: unsupervised

  enableSuperuserAccess: false
  bootstrap:
    initdb:
      database: gitlabhq_production
      owner: gitlab

  # Require 1Gi of space
  storage:
    storageClass: longhorn
    size: 5Gi
```


## Troubleshooting commands

## Troubleshooting Topics

## Resources

