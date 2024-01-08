# OWASP K01: Insecure Workload Configurations

## Description

Manifests have many different configurations and options that can be included when creating them. This is the most common vulnerbility, where best-practices are not followed and insecure configurations are allowed to be included in production level envirements. 

## General points to keep in mind

1. Application processes running inside of a container should rarely be run as **root** unless absolutely neccessary for the workload to function. If an attacker gains access to the container they can create their own processes and potentially escape.
2. Use **Read-only** filesystems whenever you can. It can help contain a compromised container by not allowing it to write back to the host.
3. Avoid running containers as **Privileged** as it removes numerous built in container isolation mechanisms and gives the container access to the kernel and additional resources. **It is extremely dangerous to run a privileged container with a root user, as this gives almost complete access to the host device**.

## Prevention / Remediation

1. Avoid running as root user
2. Avoid running in privileged mode
3. Use read-only as much as possible
4. Set AllowPrivilegeEscalation: False in the kubernetes manifests to stop child processes from getting more privileges than their parent.
5. For indepth prevention, read through this quick 329 page [CIS Benchmark for Kubernetes](../attachments/CIS-Kubernetes-Benchmark-v1.8.0.pdf)

## Examples

Running as root vs non-root

    apiVersion: v1  
    kind: Pod  
    metadata:  
    name: root-user
    spec:  
    containers:
    ...
    securityContext:  
        #root user:
        runAsUser: 0
        #non-root user:
        runAsUser: 5554

---

Explicitly defining a read only file system

    securityContext:  
        #read-only fs explicitly defined
        readOnlyRootFilesystem: true

---

Privileged container

    securityContext:  
        #priviliged 
        privileged: true
        #non-privileged 
        privileged: false

---

https://owasp.org/www-project-kubernetes-top-ten/2022/en/src/K01-insecure-workload-configurations