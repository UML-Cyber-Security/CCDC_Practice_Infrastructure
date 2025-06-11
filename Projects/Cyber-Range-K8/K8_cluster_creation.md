
# Kubernetes Cluster Creation Notes

## TOC
- [Kubernetes Cluster Creation Notes](#kubernetes-cluster-creation-notes)
  - [TOC](#toc)
  - [Prerequisites](#prerequisites)
  - [Steps](#steps)
    - [Install Docker on Each Machine](#install-docker-on-each-machine)
    - [Install Kubernetes Components on Each Machine](#install-kubernetes-components-on-each-machine)
  - [Step 1: Initialize the Control Plane](#step-1-initialize-the-control-plane)
    - [Step 1.1: Set Up kubeconfig for kubectl on Control Plane](#step-11-set-up-kubeconfig-for-kubectl-on-control-plane)
    - [Step 1.2: Deploy a Pod Network(In This Case, Calico)](#step-12-deploy-a-pod-networkin-this-case-calico)
      - [Why?](#why)
  - [Step 2: Join Worker Nodes to the Cluster](#step-2-join-worker-nodes-to-the-cluster)
  - [Step 3: Verify the Cluster](#step-3-verify-the-cluster)
    - [Troubleshooting](#troubleshooting)
  - [Notes](#notes)



## Prerequisites
1. Ensure all machines (control plane and worker nodes) are running a compatible Linux OS.
   
## Steps
1. Install Docker or another container runtime on each machine.
2. Install `kubeadm`, `kubelet`, and `kubectl` on each machine.

### Install Docker on Each Machine
```sh
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo systemctl enable docker
    sudo systemctl start docker
```

### Install Kubernetes Components on Each Machine
```sh
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
```

## Step 1: Initialize the Control Plane
On the control plane (master) node:

```sh
sudo kubeadm init --apiserver-advertise-address=<control-plane-ip> --pod-network-cidr=192.168.0.0/16
```
cidr is based of control plane ip.

### Step 1.1: Set Up kubeconfig for kubectl on Control Plane
Installs the command line for k8 + allows the current user blueteam to use kubectl.
```sh 
sudo mkdir -p /home/blueteam/.kube
sudo cp /etc/kubernetes/admin.conf /home/blueteam/.kube/config
sudo chown blueteam:blueteam /home/blueteam/.kube/config
```

### Step 1.2: Deploy a Pod Network(In This Case, Calico)

This is a required step, do not make the same mistake I made.
```sh
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

#### Why?
Pod to Pod communcation:K8 requires a pod network layer for the pods to communicate
Network Policies: Add-ons like Calico also enable you to implement network policies that can restrict how pods communicate with each other, enhancing the security of your cluster.
Cluster Scalability: Efficient networking is crucial for cluster scalability. It ensures that as your cluster grows, network performance remains stable and reliable.

## Step 2: Join Worker Nodes to the Cluster
*remember each Node needs to have kubeadm installed.*
On each worker node:

1. **Obtain the `kubeadm join` command** from the control plane:
   ```sh
   kubeadm token create --print-join-command
   ```

2. **Run the `kubeadm join` command** on each worker node:
   ```sh
   sudo kubeadm join <control-plane-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
   ```

## Step 3: Verify the Cluster
On the control plane node, verify that all nodes have joined the cluster:

```sh
kubectl get nodes
```

### Troubleshooting
- Check the kubelet logs if nodes are not joining or not in `Ready` state:
  ```sh
  journalctl -u kubelet -f
  ```

- Ensure the necessary ports are open and that the worker nodes can access the required container images.
  - `netstat ano | grep <port#>`
- If you are redeploying an entirely new cluster on a machine that previously had a clsuter then make sure you delete the cluster. I spent way to much time troubleshooting when I could've simply deleted the cluster and redownloaded the program.
- 
- 
## Notes
- The `--pod-network-cidr=192.168.0.0/16` flag in the `kubeadm init` command is necessary for network add-ons like Calico.
- Ensure that the control plane IP is correct and accessible from the worker nodes.
*This is taken from my notes and added to the repo, so there are extra-explainations/suggestions that I had added for me.*