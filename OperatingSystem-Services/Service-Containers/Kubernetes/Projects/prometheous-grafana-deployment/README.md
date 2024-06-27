# Deploying Promethous and Grafana for Monitoring

[toc]

## General Information

This is a log collection and display stack to visualize logs and monitor your cluster.

Following [tutorial](https://dour-aftermath-9c9.notion.site/Kubernetes-Monitoring-Effective-Cluster-Tracking-with-Prometheus-003b2f42b3214b8e97fc7b0629baf246)

### Open Ports

## Known Requirements

## Installation

### Via helm

Values [file](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml)

Add repo & update

    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

    helm repo update

### Accessing Grafana Web UI

Credentials

    user: admin
    pass: prom-operator

## Troubleshooting commands

## Troubleshooting Topics