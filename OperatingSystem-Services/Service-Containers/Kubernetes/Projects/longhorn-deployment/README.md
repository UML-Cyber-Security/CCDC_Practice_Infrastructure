# Deploying Longhorn

[toc]

## General Information

This will deploy longhorn across all your nodes in the cluster, pooling their storage and allowing them to be accessible via a PVC.

Sidenote: Longhorn is a great solution when running a baremetal kubernetes cluster and you want to have local storage available for all the nodes and useable by statefulsets (databases). However, it is not necessarily needed if you already have a NFS solution or some other provided csi.

### Open Ports

- If wanting to use UI dashboard requires ingress via port 80

## Included Files

- longhorn-ingress.yml
  - This is for the longhorn dashboard. The ingress is set up to use cert-manager via a clusterissuer.

## Known Requirements

- Base VMS/Machines MUST have enough space or you will run into disk pressure errors. I found 30GB free+ worked.

## Installation

### Longhorn Via Helm

Add longhorn Repo and update

    helm repo add longhorn https://charts.longhorn.io
    
    helm repo update

Install longhorn in its own namespace

    helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.5.3

Check success

    kubectl -n longhorn-system get pod

### Longhorn Manually (Kubectl)

Apply the manifest

    kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.5.3/deploy/longhorn.yaml

If you want to look at it before applying

    wget https://raw.githubusercontent.com/longhorn/longhorn/v1.5.3/deploy/longhorn.yaml\

    kubectl apply -f longhorn.yaml

Check success

    kubectl get pods --namespace longhorn-system --watch

### Testing

To test this, create a PVC using the storageClassName longhorn.

    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
    name: pihole-etc-longhorn-claim
    namespace: homelab
    spec:
    storageClassName: longhorn
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
        storage: 5Gi

Then, claim it for a deployment under volumes,

    spec:
    replicas: 1
    selector:
        matchLabels:
        app: pihole
    template:
        metadata:
        labels:
            app: pihole
        spec:
        containers:
        - name: pihole
            image: pihole/pihole:latest
            ...
            volumeMounts:
            - name: etc
            mountPath: "/etc/pihole"
            - name: dnsmasq
            mountPath: "/etc/dnsmasq.d"
        volumes:
            - name: etc
            persistentVolumeClaim:
                claimName: pihole-etc-longhorn-claim
            - name: dnsmasq
            persistentVolumeClaim:
                claimName: pihole-dnsmasq-longhorn-claim


## Troubleshooting commands

## Troubleshooting Topics

