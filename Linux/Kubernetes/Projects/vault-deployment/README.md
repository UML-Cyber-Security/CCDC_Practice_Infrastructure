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


Now we need to unseal the vault. Whether you have 1 pod or multiple running vault, just choose one. Then run the following command with the chosen pod.

    kubectl exec -ti vault-0 -- vault operator init

This will have the following output.

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

In this case, it says the unseal threshold is 3 keys. So using 3 unique keys from the 5 given above, run the following commands. (The only thing you are changing is the vault-0 name for what pod you used, and the Unseal Key # to use 3 different keys.)

    kubectl exec -ti vault-0 -- vault operator unseal # ... Unseal Key 1
    kubectl exec -ti vault-0 -- vault operator unseal # ... Unseal Key 2
    kubectl exec -ti vault-0 -- vault operator unseal # ... Unseal Key 3

Check that your vault pod is correctly running now, then head over to the UI to log in. It will ask for a token, which is the *Initial Root Token* from above. To find it where it is running, you should check your services and look for whatever IP your loadbalancer gave it (Or whatever method you used)

    kubectl get services

TODO Get TLS working
### Deploying Vault Internally in Standalone mode with TLS

[Resource](https://developer.hashicorp.com/vault/docs/platform/k8s/helm/examples/standalone-tls)

## Troubleshooting commands

## Troubleshooting Topics
