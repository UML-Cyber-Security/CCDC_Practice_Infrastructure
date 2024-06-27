# Deploying Vault

[toc]

## General Information

This will deploy a vault server in standalone mode. 

### Open Ports

## Known Requirements

- Base VMS/Machines MUST have enough space or you will run into disk pressure errors. I found 30GB free+ worked.

## Installation

### Installing Vault on Rocky Linux 99

Always check the official [site](https://developer.hashicorp.com/vault) for updates

    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install vault

### Deploying Vault Internally in Standalone mode Without TLS (Simplest method)

We will use helm, but we need to change some chart values first. Create a file called vault-helm-values.yml and add the following info,

```yaml
server:
  # We are doing standalone because its more secure than Dev and HA requires atleast 5 nodes, we only have 3.
  standalone:
    enabled: true
    config: |
      ui = true

      listener "tcp" {
        tls_disable = 1
        address = "[::]:8200"
        cluster_address = "[::]:8201"
      }
      storage "file" {
        path = "/vault/data"
      }

  service:
    enabled: true

  # This is the most important part, you MUST supply an existing storageclass, for example an NFS share you set up for this to work. Also make sure the accessMode is matching the shares accessmode. In this example, my csi-nfs-1 storageClass is the nfs share from ### Installing CSI driver for NFS Storage above.
  dataStorage:
    enabled: true
    size: 10Gi
    storageClass: csi-nfs-1
    accessMode: ReadWriteMany

ui:
  enabled: true
  serviceType: LoadBalancer
```

### Deploying Vault Internally in HA mode with TLS enabled

Add Repo & Update

    helm repo add hashicorp https://helm.releases.hashicorp.com

    helm repo update

#### Creating Certificate

Temp Working Directory

    mkdir /tmp/vault

Make easy with tmp vars, change to what you want.

```bash
export VAULT_K8S_NAMESPACE="vault" \
export VAULT_HELM_RELEASE_NAME="vault" \
export VAULT_SERVICE_NAME="vault-internal" \
export K8S_CLUSTER_NAME="cluster.local" \
export WORKDIR=/tmp/vault
```

Sidenote: K8S_CLUSTER_NAME can be found with the following command (Tested on k8s and kubeadm)

    kubectl config view --minify -o jsonpath='{.clusters[].name}'

Generate private key

    openssl genrsa -out ${WORKDIR}/vault.key 2048

Create CSR (Certificate Signing Request) config file

```bash
cat > ${WORKDIR}/vault-csr.conf <<EOF
[req]
default_bits = 2048
prompt = no
encrypt_key = yes
default_md = sha256
distinguished_name = kubelet_serving
req_extensions = v3_req
[ kubelet_serving ]
O = system:nodes
CN = system:node:*.${VAULT_K8S_NAMESPACE}.svc.${K8S_CLUSTER_NAME}
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.${VAULT_SERVICE_NAME}
DNS.2 = *.${VAULT_SERVICE_NAME}.${VAULT_K8S_NAMESPACE}.svc.${K8S_CLUSTER_NAME}
DNS.3 = *.${VAULT_K8S_NAMESPACE}
IP.1 = 127.0.0.1
EOF
```
Generate CSR

    openssl req -new -key ${WORKDIR}/vault.key -out ${WORKDIR}/vault.csr -config ${WORKDIR}/vault-csr.conf

Create CSR Yaml file to send to Kubernetes

```bash
cat > ${WORKDIR}/csr.yaml <<EOF
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: vault.svc
spec:
  signerName: kubernetes.io/kubelet-serving
  expirationSeconds: 8640000
  request: $(cat ${WORKDIR}/vault.csr|base64|tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
```

Send to cluster

    kubectl create -f ${WORKDIR}/csr.yaml

Approve CSR with Cluster

    kubectl certificate approve vault.svc

Confirm certificate signed

    kubectl get csr

#### Store cert + key in Kubernetes secret store

Retreive cert from kubernetes to local

    kubectl get csr vault.svc -o jsonpath='{.status.certificate}' | openssl base64 -d -A -out ${WORKDIR}/vault.crt

Retreive kube CA certificate from kubernetes to local

```bash
kubectl config view \
--raw \
--minify \
--flatten \
-o jsonpath='{.clusters[].cluster.certificate-authority-data}' \
| base64 -d > ${WORKDIR}/vault.ca
```

Create seperate vault namespace

    kubectl create namespace $VAULT_K8S_NAMESPACE

Create TLS secret

```bash
kubectl create secret generic vault-ha-tls \
-n $VAULT_K8S_NAMESPACE \
--from-file=vault.key=${WORKDIR}/vault.key \
--from-file=vault.crt=${WORKDIR}/vault.crt \
--from-file=vault.ca=${WORKDIR}/vault.ca
```

#### Override values + Deploy

```yaml
global:
  enabled: true
  tlsDisable: false
injector:
  enabled: true
server:
  # This is suing longhorn as CNI, you can substitute with some other storage supporting stateful such as NFS. This is used by the ha raft config below.
  dataStorage:
    enabled: true 
    size: 4Gi
    mountPath: "/vault/data"
    storageClass: longhorn
    accessMode: ReadWriteOnce
  extraEnvironmentVars:
    VAULT_CACERT: /vault/userconfig/vault-ha-tls/vault.ca
    VAULT_TLSCERT: /vault/userconfig/vault-ha-tls/vault.crt
    VAULT_TLSKEY: /vault/userconfig/vault-ha-tls/vault.key
  # This is not a local mount, it is mounting a secret directly into the container.
  volumes:
    - name: userconfig-vault-ha-tls
      secret:
        defaultMode: 420
        secretName: vault-ha-tls
  volumeMounts:
    - mountPath: /vault/userconfig/vault-ha-tls
      name: userconfig-vault-ha-tls
      readOnly: true
  standalone:
    enabled: false
  affinity: ""
  ha:
    enabled: true
    replicas: 3
    raft:
        enabled: true
        setNodeId: true
        config: |
          ui = true
          listener "tcp" {
              tls_disable = 0
              address = "[::]:8200"
              cluster_address = "[::]:8201"
              tls_cert_file = "/vault/userconfig/vault-ha-tls/vault.crt"
              tls_key_file  = "/vault/userconfig/vault-ha-tls/vault.key"
              tls_client_ca_file = "/vault/userconfig/vault-ha-tls/vault.ca"
          }
          storage "raft" {
              path = "/vault/data"
          }
          disable_mlock = true
          service_registration "kubernetes" {}
```

```bash
helm install vault hashicorp/vault --namespace vault -f values.yml
```

## Unsealing Vault after using one of above methods

Now we need to unseal the vault. Whether you have 1 pod or multiple running vault, just choose one. Then run the following command with the chosen pod.

    kubectl exec -ti vault-0 -- vault operator init

If you already installed it or installed it before, it may still have all its data in the same PVC. Either delete it for a fresh start, or just unseal the vault after reconfiguring it. (Need to do 3 times to put the keys in, then you can skip everything below this.)

    kubectl exec -ti vault-0 -- vault operator unseal

This will have the following output.

```bash
Unseal Key 1: MBFSDepD9E6whREc6Dj+k3pMaKJ6cCnCUWcySJQymObb
Unseal Key 2: zQj4v22k9ixegS+94HJwmIaWLBL3nZHe1i+b/wHz25fr
Unseal Key 3: 7dbPPeeGGW3SmeBFFo04peCKkXFuuyKc8b2DuntA4VU5
Unseal Key 4: tLt+ME7Z7hYUATfWnuQdfCEgnKA2L173dptAwfmenCdf
Unseal Key 5: vYt9bxLr0+OzJ8m7c7cNMFj7nvdLljj0xWRbpLezFAI9

Initial Root Token: s.zJNwZlRrqISjyBHFMiEca6GF

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 3 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```


In this case, it says the unseal threshold is 3 keys. So using 3 unique keys from the 5 given above, run the following commands. (The only thing you are changing is the vault-0 name for what pod you used, and the Unseal Key # to use 3 different keys.)

    kubectl exec -ti vault-0 -- vault operator unseal # ... Unseal Key 1
    kubectl exec -ti vault-0 -- vault operator unseal # ... Unseal Key 2
    kubectl exec -ti vault-0 -- vault operator unseal # ... Unseal Key 3

Check that your vault pod is correctly running now, then head over to the UI to log in. It will ask for a token, which is the *Initial Root Token* from above. To find it where it is running, you should check your services and look for whatever IP your loadbalancer gave it (Or whatever method you used)

    kubectl get services

## Troubleshooting commands

## Troubleshooting Topics

## Resources

[Standalone No TLS Install](https://developer.hashicorp.com/vault/docs/platform/k8s/helm/examples/standalone-tls)

[HA W/ TLS](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-tls)

[TEMP _ HIGH LEVEL VAULT](https://developer.hashicorp.com/vault/docs/secrets/pki)

[TEMP _ Vault create CA](https://developer.hashicorp.com/vault/tutorials/secrets-management/pki-engine?variants=vault-deploy%3Aselfhosted)

[TEMP _ VAULT + CERT MANAGER](https://cert-manager.io/docs/configuration/vault/)