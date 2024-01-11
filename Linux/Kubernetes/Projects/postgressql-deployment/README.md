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



## Troubleshooting commands

## Troubleshooting Topics