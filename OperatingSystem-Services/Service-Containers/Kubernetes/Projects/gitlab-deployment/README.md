# Deploying Gitlab

[toc]

## General Information

This will deploy a replicated gitlab server. 

### Open Ports

- Ingress points to
  - kas.your-domain.com
  - gitlab.your-domain.com
  - registry.your-domain.com
  - minio.your-domain.com

## Known Requirements

- Cert-Manager configured with a ClusterIssuer
- Nginx ingress controller (See Configuring Ingress for required flag)
- postgressql HA

## Installation

### Configuring Ingress

I already have nginx ingress controller installed on my cluster via helm, so I am going to configure the ingress. I must add this to the values file.

    tcp:
        22: "gitlab/mygitlab-gitlab-shell:22"

### Configuring the values File

By default, the gitlab helm chart deploys its own subchart deployment of cert-manager, nginx-ingress-controller, prometheous, postgressql, redis, and some others. We are going to be using our own postgressql HA server, cert-manager, and nginx-ingress controller, so we disable those in the values. We also supply our postgressql secrets, our hosts for cert-manager, and some annotations. Everything is explained on the values file in detail.


### Getting via Helm

    helm repo add gitlab https://charts.gitlab.io/
    helm repo update
    helm upgrade --install gitlab gitlab/gitlab -f values.yml


### First Login

Access the domain you set it to in a browser.

Retreive the autogenerated secret and use it as the password, with the username being `root`

    kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo

## Troubleshooting commands

## Troubleshooting Topics

### Ingress not getting assigned IP Address

My ingress certificate was going through, but I wasn't getting assigned an IP address. This was due to the values file being incorrect under 

    global:
      ingress:
        class: nginx-hadsomethingelse

I am using nginx-ingress-controller, so the class needed to be nginx. Once I changed that it worked.

### Pods were getting stuck deploying

I had incorrectly set the host for the postgressql backend database under

    psql:
      host: gitlab-rw

Ensure it is the correct gitlab RW service. Can check with kubectl get services.