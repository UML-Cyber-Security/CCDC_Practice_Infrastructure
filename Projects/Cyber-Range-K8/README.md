# Project Overview

Project Overview
This project aims to migrate services to a Kubernetes (K8s) cluster using Ansible scripts, ensuring minimal downtime, secure deployment, and seamless data transfer. The migration will involve deploying services on both k8 clusters and LXC-contained clusters, and the strategy will hopefullt be adapted to work with existing clusters.

## PLAN
### Goal
1. Automate the deployment of services using Ansible on a K8s cluster.
2. Migrate cluster information to an entirely new cluster
3. Generalize the script to work for different machines, in prep for competiton   
### Steps:
1. Set Up a test environment manually
2. Set Up a test environment automatically using ansible
3. Migrate cluster infomation manually
4. Migrate cluster infomation automaticall using ansible
5. Consolidate & Generalize the steps and information for use in the competition



#### Current issues.
- Cluster is currenlty down....
    > setup VMs on personal machine

- Migratation sucks...