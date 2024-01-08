# Kubernetes Presentation

Author: Andrew A

Date: 2022 Aug 08

## Namespaces
### Namespaced Resources
```bash
# In a namespace
kubectl api-resources --namespaced=true

# Not in a namespace
kubectl api-resources --namespaced=false
```

### Set default namespace
```bash
kubectl config set-context --current --namespace=<NAME>
```

### Create
```bash
kubectl create namespace <NAME>
```

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: <NAME>
```

### View
```bash
kubectl get namespace

kubectl describe namespace <NAME>
```

### Doc
[Namespaces Walkthrough](https://kubernetes.io/docs/tasks/administer-cluster/namespaces-walkthrough/)


## Workloads
### Pods
#### Creating
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: <POD_NAME>
spec:
  containers:
  - name: <CONTAINER_NAME>
    image: nginx:1.14.2
```

```bash
kubectl run <NAME> --image=nginx
```

#### Delete
```bash
kubectl delete pod <NAME>
```

#### Pod phase
| Status | Description |
| --- | --- |
| Pending | The Pod has been accepted by the Kubernetes cluster, but one or more of the containers has not been set up and made ready to run. This includes time a Pod spends waiting to be scheduled as well as the time spent downloading container images over the network. |
| Running | The Pod has been bound to a node, and all of the containers have been created. At least one container is still running, or is in the process of starting or restarting. |
| Succeeded | All containers in the Pod have terminated in success, and will not be restarted. |
| Failed | All containers in the Pod have terminated, and at least one container has terminated in failure. That is, the container either exited with non-zero status or was terminated by the system. |
| Unknown | For some reason the state of the Pod could not be obtained. This phase typically occurs due to an error in communicating with the node where the Pod should be running. |

#### Container states
| Status | Description |
| --- | --- |
| Waiting | If a container is not in either the Running or Terminated state, it is Waiting. A container in the Waiting state is still running the operations it requires in order to complete start up |
| Running | The Running status indicates that a container is executing without issues. If there was a postStart hook configured, it has already executed and finished. When you use kubectl to query a Pod with a container that is Running, you also see information about when the container entered the Running state |
| Terminated | A container in the Terminated state began execution and then either ran to completion or failed for some reason. When you use kubectl to query a Pod with a container that is Terminated, you see a reason, an exit code, and the start and finish time for that container's period of execution. |


### Deployments
#### Create
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: <DEPLOYMENT_NAME>
spec:
  replicas: 3
  selector:
    matchLabels:
      key1: value1
  template:
    metadata:
      labels:
        key1: value1
    spec:
      containers:
      - name: <CONTAINER_NAME>
        image: nginx:1.14.2
```

```yaml
kubectl create deployment nginx-deployment --replicas=3 --image nginx:1.14.2
```

#### Editing
```bash
kubectl edit deployment <DEPLOYMENT_NAME>

kubectl rollout status deployment <DEPLOYMENT_NAME>

kubectl scale deployment <DEPLOYMENT_NAME> --replicas=4
```

### DaemonSets
Will create a pod on each node.

#### Creating
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata: 
  name: NAME
spec:
  selector:
    matchLabels:
      name: LABEL-NAME
  template:
    metadata:
      labels:
        name: LABEL-NAME
    spec:
      containers:
      - name: NAME
        image: IMAGE
```


### Jobs
Jobs are a once off pod, they are used for solutions that have an end in mind.

`completions` the amount of pods to run
`parallelism` how many pods to run in parallel

#### Create
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  backoffLimit: 4
  completions: 3
  parallelism: 3
  template:
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
```


### CronJobs
Cronjobs are scheduled jobs.

#### Create
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: pi-cronjob
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      backoffLimit: 4
		  completions: 3
		  parallelism: 3
		  template:
		    spec:
		      containers:
		      - name: pi
		        image: perl
		        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
		      restartPolicy: Never
```


## Config

### ConfigMaps
Used to store non sensitive configuration data.

#### Creating
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: <map-name>
data:
  KEY: VALUE
```

```bash
kubectl create configmap <map-name> --from-literal=KEY=VALUE

kubectl create configmap <map-name> --from-file=config_data.txt
```
When specifying a file values should be stored in `KEY: VALUE` format

#### Using
Can be mounted onto a container as environment variables or mounted as files

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-demo-pod
spec:
  containers:
    - name: demo
      image: alpine
      envFrom:
      - configMapRef:
        name: CM-VAR
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-demo-pod
spec:
  containers:
    - name: demo
      image: alpine
      volumeMounts:
      - name: config
        mountPath: "/config"
        readOnly: true
  volumes:
    - name: config
      configMap:
        name: CM-VAR
        items:
        - key: "KEY"
          path: "KEY"
```

### Secrets
Secrets are like configmaps but intended to store sensitive data.

#### Create
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret-sample
type: generic
data:
  extra: YmFyCg==  # Base64
```

```bash
kubectl create secret generic db-user-pass --from-literal=username=devuser
```

#### Usage
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
spec:
  containers:
  - name: mycontainer
    image: redis
    env:
    - name: SECRET_USERNAME
      valueFrom:
        secretKeyRef:
          name: mysecret
          key: username
	  envFrom:
    - secretRef:
      name: mysecret
```


## Network
### Services
Used for communication between pods & externally.

Types of services:
- NodePort
- ClusterIP
- LoadBalancer

#### NodePort
![Untitled](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/99a1bc6e-4e9e-4b51-86ac-3883975bf45e/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220801%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220801T174147Z&X-Amz-Expires=86400&X-Amz-Signature=a09b7205b82b98b6cb4564ca83d00faf855dbb3d327e60d93143663a40938bfc&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22&x-id=GetObject)

Port range 30000 through 32767

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: MyApp
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30007
```

#### ClusterIP
Internal networking

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
	type: ClusterIP
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

#### LoadBalancer
Exposes the Service externally using a cloud provider's load balancer. NodePort and ClusterIP Services, to which the external load balancer routes, are automatically created.

[Documentation](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)

### Ingresses
OSI Layer 7 load balance built into k8s, still needs NodePort or LoadBalancer service

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx-example
  rules:
  - http:
      paths:
      - path: /testpath
        pathType: Prefix
        backend:
          service:
            name: test
            port:
              number: 80
```

#### Docs
[Kubectl Reference Docs](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-em-ingress-em-)
[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

## Storage
### Persistent Volume Claim
Allocate a block of storage.

#### Create PVC
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: foo-pvc
  namespace: foo
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

#### Usage on pod
```yaml
# spec.
  volumes:
  - name: mypd
    persistentVolumeClaim:
      claimName: myclaim
```

### Persistent Volumes
Unit of claimable storage.

#### Volumes on Pods
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pv-recycler
spec:
  volumes:
  - name: vol
    hostPath:
      path: /any/path/it/will/be/replaced
  - name: demo-volume
    emptyDir: {}
  containers:
  - name: pv-recycler
    image: "k8s.gcr.io/busybox"
    volumeMounts:
    - name: vol
      mountPath: /scrub
```

#### Persistent Volume
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: foo-pv
spec:
  accessMode:
  - ReadWriteOnce
  capacity:
    storage: 1Gi
  hostPath:
    path: /foo
```

#### Docs
[Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

### Storage Classes
A StorageClass provides a way for administrators to describe the "classes" of storage they offer. Different classes might map to quality-of-service levels, or to backup policies, or to arbitrary policies determined by the cluster administrators

#### Docs
[Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)



## Access Control & Security
### Security Context
Grant other capabilities to pods and/or containers.
When added under `spec.securityContext` applies to the pod, when `spec.containers[].securityContext` applies the the container.

#### Usage
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-4
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 1003
  containers:
  - name: sec-ctx-4
    image: gcr.io/google-samples/node-hello:1.0
```
Specify what `user / groups` to run the pod **security-context-demo-4** as.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-4
spec:
  containers:
  - name: sec-ctx-4
    image: gcr.io/google-samples/node-hello:1.0
    securityContext:
      capabilities:
        add: ["NET_ADMIN", "SYS_TIME"]
```
Grant `NET_ADMIN` & `SYS_TIME` to the container **sec-ctx-4**.

#### Docs
[Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)

### Service Accounts

```yaml
kubectl create serviceaccount NAME
```

Token is stored in a k8s secret

Default service account for each namespace, & then mounted to the pod as a volume.

Change the service account for the pod `Pod.spec.serviceAccountName`

Configure not to mount `Pod.spec.automountServiceAccountToken: false`

Can also be configured with RBAC 

[Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-binding-examples)

### [Cluster] Roles

#### Creating a role

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: developer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list", "create","delete"]
```

```yaml
kubectl create role developer --namespace=default --verb=list,create,delete --resource=pods
```

#### Cluster Roles

```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: node-admin
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "watch", "list", "create", "delete"]
```

### [Cluster] Role Bindings

#### Creating a role binding

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dev-user-binding
subjects:
- kind: User
  name: dev-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```

```yaml
kubectl create rolebinding dev-user-binding --namespace=default --role=developer --user=dev-user
```

#### Creating a cluster role binding

```yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: admin-binding
subjects:
- kind: User
  name: aaiken
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: node-admin
  apiGroup: rbac.authorization.k8s.io
```

### Network Policies
Restrict access between resources

#### Usage
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978
```

#### Docs
[Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

### Certificates

#### Generate
```bash
# Create key
openssl genrsa -out user.key 4096

# Create csr
openssl req -new -key user.key -subj "/CN=user" -out user.csr
```

#### Certificate Signing Request
```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: user
spec:
  request: LS0tLS1CUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZqQ0NBVDRDQVFBd0VURVBNQTBHQTFVRUF3d0dZVzVuWld4aE1JSUJJakFOQmdrcWhraUc5dzBCQVFFRgpBQU9DQVE4QU1JSUJDZ0tDQVFFQTByczhJTHRHdTYxakx2dHhWTTJSVlRWMDNHWlJTWWw0dWluVWo4RElaWjBOCnR2MUZtRVFSd3VoaUZsOFEzcWl0Qm0wMUFSMkNJVXBGd2ZzSjZ4MXF3ckJzVkhZbGlBNVhwRVpZM3ExcGswSDQKM3Z3aGJlK1o2MVNrVHF5SVBYUUwrTWM5T1Nsbm0xb0R2N0NtSkZNMUlMRVI3QTVGZnZKOEdFRjJ6dHBoaUlFMwpub1dtdHNZb3JuT2wzc2lHQ2ZGZzR4Zmd4eW8ybmlneFNVekl1bXNnVm9PM2ttT0x1RVF6cXpkakJ3TFJXbWlECklmMXBMWnoyalVnald4UkhCM1gyWnVVV1d1T09PZnpXM01LaE8ybHEvZi9DdS8wYk83c0x0MCt3U2ZMSU91TFcKcW90blZtRmxMMytqTy82WDNDKzBERHk5aUtwbXJjVDBnWGZLemE1dHJRSURBUUFCb0FBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnRUJBR05WdmVIOGR4ZzNvK21VeVRkbmFjVmQ1N24zSkExdnZEU1JWREkyQTZ1eXN3ZFp1L1BVCkkwZXpZWFV0RVNnSk1IRmQycVVNMjNuNVJsSXJ3R0xuUXFISUh5VStWWHhsdnZsRnpNOVpEWllSTmU3QlJvYXgKQVlEdUI5STZXT3FYbkFvczFqRmxNUG5NbFpqdU5kSGxpT1BjTU1oNndLaTZzZFhpVStHYTJ2RUVLY01jSVUyRgpvU2djUWdMYTk0aEpacGk3ZnNMdm1OQUxoT045UHdNMGM1dVJVejV4T0dGMUtCbWRSeEgvbUNOS2JKYjFRQm1HCkkwYitEUEdaTktXTU0xMzhIQXdoV0tkNjVoVHdYOWl4V3ZHMkh4TG1WQzg0L1BHT0tWQW9FNkpsYWFHdTlQVmkKdjlOSjVaZlZrcXdCd0hKbzZXdk9xVlA3SVFjZmg3d0drWm89Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=
  groups:
  - system:authenticated
  usages:
  - digital signature
  - key encipherrment
  - server auth
```
`spec.request` is base64 of the **user.csr** 
```bash
cat ./user.csr | base64 | tr -d '\n'
```

#### Approving request
```bash
# View csr
kubectl get csr

# Approve the csr
kubectl certificate approve user
```

[Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)

## Components

![image.svg](https://d33wubrfki0l68.cloudfront.net/2475489eaf20163ec0f54ddc1d92aa8d4c87c96b/e7c81/images/docs/components-of-kubernetes.svg)

### Control plane components
#### kube-apiserver
The API server is a component of the Kubernetes control plane that exposes the Kubernetes API. The API server is the front end for the Kubernetes control plane.

#### etcd
Consistent and highly-available key value store used as Kubernetes' backing store for all cluster data.

#### kube-scheduler
Control plane component that watches for newly created Pods with no assigned node, and selects a node for them to run on.

#### kube-controller-manager
Control plane component that runs controller processes.
- Node controller: Responsible for noticing and responding when nodes go down.
- Job controller: Watches for Job objects that represent one-off tasks, then creates Pods to run those tasks to completion.
- Endpoints controller: Populates the Endpoints object (that is, joins Services & Pods).
- Service Account & Token controllers: Create default accounts and API access tokens for new namespaces.

### Node components
#### kubelet
An agent that runs on each node in the cluster. It makes sure that containers are running in a Pod.

#### kube-proxy
kube-proxy is a network proxy that runs on each node in your cluster, implementing part of the Kubernetes Service concept.


## Additional Learning
[Kubernetes Website](https://kubernetes.io/)
[Kubectl cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#interacting-with-running-pods)
[Free Kubernetes Cluster](https://github.com/learnk8s/free-kubernetes)
