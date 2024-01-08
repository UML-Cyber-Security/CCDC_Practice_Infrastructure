# K3D Cluster Setup

## Creating
### Create the Cluster
```bash
k3d cluster create presentation -p 30000:30000 -p 30001:30001
```

### Adding Nodes
```bash
k3d node create small-node --cluster presentation --memory 1000MB

k3d node create large-node --cluster presentation --memory 2000MB
```

### Switch to the Context
```bash
kubectl config use-context k3d-presentation
```

## Cleanup

```bash
k3d node delete k3d-small-node-0 k3d-large-node-0 

k3d cluster delete presentation
```
