
# Kubernetes Installation with Flannel on Ubuntu

## Prerequisites:
1. **Ubuntu 20.04** (or later) installed on two or more nodes (one master and at least one worker).
2. **At least 4 CPUs and 4 GB of RAM** on each node.
3. **Root or sudo access** to execute commands.
4. **All nodes should have a unique hostname**.
5. **Firewall rules** allowing traffic between nodes on required ports.
6. **Check sudoers file for sudo vim. If there delete it. IMMEDIATELY

## Step 1: Update the system
```bash
sudo apt update && sudo apt upgrade -y
```
- **`sudo`**: Grants superuser privileges to execute administrative commands.
- **`apt update`**: Updates the package list from repositories.
- **`apt upgrade -y`**: Installs newer versions of packages; `-y` confirms yes to prompts.

## Step 2: Disable Swap
Kubernetes requires swap to be disabled for proper functionality.

```bash
sudo swapoff -a  **REQUIRED
```
- **`swapoff -a`**: Turns off swap immediately, which is needed because Kubernetes won't work with swap enabled.

**OPTIONAL I have never done it myself-Rohan
To ensure swap remains off after reboot, modify the `/etc/fstab` file and comment out any lines that reference swap.

```bash
sudo sed -i '/ swap / s/^\(.*\)$/#/g' /etc/fstab
```
- **`sed -i '/ swap / s/^\(.*\)$/#/g'`**: Finds and comments out swap entries in `/etc/fstab`, which prevents swap from being enabled after reboot.

## Step 3: Install Docker
Kubernetes uses Docker as the container runtime.

```bash
sudo apt install -y docker.io
```
- **`apt install -y docker.io`**: Installs Docker, the container runtime that will be used by Kubernetes.

Start and enable Docker to run on boot:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```
- **`systemctl enable docker`**: Ensures Docker starts on system boot.
- **`systemctl start docker`**: Starts the Docker service immediately.

## Step 4: Install Kubernetes (kubeadm, kubelet, kubectl)

```bash
## Install K8s packages from repository
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

## Update the package list and install `kubelet`, `kubeadm`, and `kubectl`:

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
```
- **`kubelet`**: The primary node agent that runs and manages container pods.
- **`kubeadm`**: Simplifies Kubernetes cluster setup.
- **`kubectl`**: A command-line tool used to interact with the Kubernetes API.

Ensure these services are enabled:

```bash
sudo systemctl enable kubelet
sudo systemctl enable kubeadm
sudo systemctl enable kubectl
```
- **`systemctl enable kubelet, kubeadm, kubectl`**: Ensures the Kubernetes node agent (kubelet) starts on boot.

Freeze the packages at their current version to make sure it they dont accidently automatically update the cluster and casue certain services to possibly become no longer wokring because of it.

```bash
sudo apt-mark hold kubelet kubeadm kubectl
```

## Step 5: Initialize the Master Node

On the master node, initialize the Kubernetes control plane with `kubeadm`:

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```
- **`kubeadm init`**: Initializes the Kubernetes control plane (the master).
- **`--pod-network-cidr=10.244.0.0/16`**: Specifies the CIDR for the pod network, which Flannel uses.

After running this command, Kubernetes will generate instructions for configuring the cluster.

To allow your user to interact with Kubernetes, set up the kubeconfig file:

```bash
mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
- **`mkdir -p $HOME/.kube`**: Creates the directory for the kubeconfig file.
- **`cp -i /etc/kubernetes/admin.conf`**: Copies the admin configuration file.
- **`chown $(id -u):$(id -g)`**: Changes ownership of the kubeconfig file to the current user.

## Step 6: Install Flannel (Pod Network)

Flannel is a popular CNI (Container Network Interface) plugin that provides networking for Kubernetes.

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
- **`kubectl apply -f`**: Tells Kubernetes to apply the configuration from the specified URL.
- **Flannel**: A simple overlay network provider that uses the CIDR specified during `kubeadm init` to manage pod networking.

## Step 7: Join Worker Nodes to the Cluster

On each worker node, run the command provided by the master node after initialization. It looks like this:

```bash
sudo kubeadm join <master-ip>:<port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
## should appear at bottom of after the init
```
- **`kubeadm join`**: Registers the worker node with the master node using a token and certificate.
- **`<master-ip>:<port>`**: The IP address and port of the master node.
- **`<token>`**: A unique token generated by `kubeadm` during master initialization.
- **`<hash>`**: A hash to ensure the token is valid.

To regenerate the token and hash if you missed them, run this on the master:

```bash
kubeadm token create --print-join-command
```

## Step 8: Verify the Setup

On the master node, verify that all nodes have joined the cluster:

```bash
kubectl get nodes
```
- **`kubectl get nodes`**: Lists all the nodes in the Kubernetes cluster and their status.
