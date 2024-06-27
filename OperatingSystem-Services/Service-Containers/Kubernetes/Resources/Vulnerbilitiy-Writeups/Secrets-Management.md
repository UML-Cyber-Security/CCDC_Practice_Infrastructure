# OWASP K08: Secrets Management

## Description
Secrets can range from usernames and passwords to API tokens or anything that may be considered a sensitive data. By default in kubernetes, secrets are simply base64 encoded and therefore extremely dangerous to introduce into source control or even to keep lying around.

## General points to keep in mind

1. Kubernetes etcd database is a great target for attackers as it holds the entire state of the cluster at a given time. This introduces encryption requirements, as it is not encrypted by default. Consider backup encryption or full disk encryption. As of recent versions, Kubernetes also offers encryption at rest for secrets within etcd, which can fluke an attacker if they do somehow gain access to the etcd backup or current state.
2. Ensure the underlying security of the cluster is up to date and protected. This includes looking at RBAC configurations, [service accounts](https://kubernetes.io/docs/concepts/security/service-accounts/), policy enforcement and image security. In the context, the focus of this should be how it gives access to secrets, but is also important to have the underlying security solid as well.
3. Ensure logging to detect any unauthorized access to secrets or to discover potentially weak security configurations.


## Prevention / Remediation

1. Kubernetes [encryption at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/) for secrets.
2. RBAC [Good Practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)
3. Enable [kubernetes auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)

## Examples

Attack scenario: An attacker has gained a shell to a web server running on a Node in Kubernetes. They check the following directory to see if the container has secrets mounted.

    ls /var/run/secrets/kubernetes.io/serviceaccount

They find that it is, and continue to install kubectl to interact with the cluster api. The web server is running in a pod, which will by default use the default service account which would be located in the above directory. If the service account was not reviewed, and the RBAC was not tuned, this attacker could not deploy their own services onto the cluster and have the ability to read secrets. (GG)

In Prevention / Remediation above, step 1 would have prevented them from reading any secrets after gaining access. Step 2 would have stopped them from being able to deploy anything to the cluster or interact with the api in a significant manner, and step 3 would have detected this activity and allowed swift resolution. 

---

## Sources

https://owasp.org/www-project-kubernetes-top-ten/2022/en/src/K08-secrets-management

https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/

https://kubernetes.io/docs/concepts/security/service-accounts/

https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/
