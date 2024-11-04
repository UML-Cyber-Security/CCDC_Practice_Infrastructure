**[Kubernetes](https://kubernetes.io/docs/home/)** is an open source platform for managing containerized workloads/services through automation.

Kubernetes is necessary to ensure that there is no downtime of bundled applications.

Kubernetes provides the user with a framework to run distributed systems resiliently, handling scaling and failover (provides deployment patterns).

### Kubernetes provides:
- **Service Discovery and Load Balancing**
	- Can expose a container using DNS or own IP Address
	- If traffic to a container is high, it can load balance and distribute network traffic for stability
- **Storage Orchestration**
	- Allows automatic mount to storage system of choice (local, cloud, etc)
- **Automated Rollouts and Rollbacks**
	- Can change actual state to desired at a controlled rate (ex. automate removal/additional deployment of containers and adopt its resources)
- **Automatic Bin Packing**
	- Run containerized tasks through cluster nodes (specific resource allocation)
- **Self-Healing**
	- Restarts containers that fail, replaces/kills containers that dont respond
- **Secret & Configuration Management**
	- Store/Manage sensitive information (passwords, OAuth tokens, & SSH keys)
	- Can deploy/update secrets without rebuilding container images & without exposes secrets in stack config
- **Batch Execution**
	- Can manage batch/CI  workloads, replacing containers that fail
- **Horizontal Scaling**
	- Scale applications up/down at ease with cmd, UI, or automation w/ CPU
- **IPv4 & IPv6 Dual-Stack**
	- Allocation of both addresses to Pods/Services
- **Designed for Extensibility**
	- Add features to cluster without changing upstream source code

Kubernetes isn't a normal PaaS (Platform as a Service) system. Operates at the container level (not hardware) and provides integration of logging, monitoring, and altering solutions (as well as what was stated above). 

### Kubernetes DOES NOT
- **Limit** types of applications supported (can provide stateless, stateful, etc)
- **Deploy** source code 
- Provide **application-level** services (middleware, data-processing framework)
- **Dictate** logging, monitoring, and altering solutions
- **Mandate** Configuration Language 
- **Adopt** comprehensive machine configurations, maintenance, etc.

Kubernetes eliminates all need for orchestration. In contrast, Kubernetes comprises a set of independent control processes. Centralized control is not required. Creates a robust/extensible system.

![[Pasted image 20241022104211.png]]

![[Pasted image 20241022104351.png]]
*A Kubernetes cluster consists of a control plane and one or more worker nodes.*

### Control Plane Components
- **kube-apiserver**
	- Core component server that exposes the Kubernetes HTTP API
- **etcd**
	- Consistent & highly-available key value store for all API server data
- **kube-scheduler**
	- Looks for Pods not bound to nodes, and assigns each to a suitable Pod
- **kube-controller-manager**
	- Runs controllers to implement Kubernetes API behavior
- **cloud-controller-manager (optional)**
	- Integrates with underlying cloud provider(s)

### Node Components
- **kubelet**
	- Ensures that Pods are running, including their containers
- **kube-proxy (optional)**
	- Maintains network rules on nodes to implement Services
- **Container runtime**
	- Software responsible for running containers

### Add-Ons
- **DNS**
	- For cluster-wide DNS resolution 
- **Web UI (Dashboard)**
	- For cluster management via a web interface
- **Container Resource Monitoring**
	- For collecting and storing container metrics
- **Cluster-level Logging**
	- For saving container logs to a central log store


## Objects in Kubernetes
Kubernetes allows for **flexibility** in how components are deployed/managed. 

**Kubernetes objects** are persistent entities ("record of intent") in the system that are used to represent the state of the cluster.

They describe:
- What containerized applications are running (and on which nodes)
- Resources available to those applications
- Policies around how each behave (restart, upgrades, fault-tolerance, etc.)

A majority of objects include 2 nested fields that govern the configuration (**spec** & **status**). 

**Spec** sets the description of characteristics of the objects **desired state**.
**Status** describes the **current state** of the object.

**Control Panel** actively manages each objects actual state and matches it to the desired state (allowing a failing status to be replaced with the desired status through replacement).


**Example Manifest of an Object in Kubernetes**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

```

**Deployment of Manifest**
```shell
kubectl apply -f https://k8s.io/examples/application/deployment.yaml
```

### [Required Fields](https://kubernetes.io/docs/reference/kubernetes-api/)
- **apiVersion**
	- Version of Kubernetes used for creation of object
- **kind**
	- Kind of object being created
- **metadata**
	- Uniquely identifying data for object such as **name** & **UID** (optional: **namespace**)
- **spec**
	- State desired for object


> **Warning:**
> A Kubernetes object should be managed using only one technique. 

![[Pasted image 20241022111920.png]]

### Labels and Selectors

**Labels** are key/value pairs that are attached to objects such as Pods. They are used to specify identifying attributes of objects. 

Labels enable users to map their own organizational structures onto system objects. Labels do not provide uniqueness.

**Example Manifest of 2 labels on a Pod**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: label-demo
  labels:
    environment: production
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```


### Namespaces

**Namespaces** provide a mechanism for isolating groups of resources within a cluster.

For clusters with a few to tens of users, you should not need to create or think about namespaces at all.

### Annotations

**Annotations** can be used to attach arbitrary non-identifying metadata to objects.

Example usage: 
- Build, release, or image information
	- Timestamps, release IDs, git branch, PR numbers, image hashes, etc.
- Pointers to logging, monitoring, analytics, etc.
- Client library/tool information
- Phone/Page Numbers

###  Finalizers

**Finalizers** are namespace keys that tell Kubernetes to wait until specific conditions are met before fully deleting resources marked for deletion.

# Cluster Architecture

A Kubernetes cluster consists of a control plane and a set of worker machines (called nodes) that run containerized applications. 

Worker node(s) host the Pods that are components of the application workload. 
The control plane manages the worker nodes and the Pods in the cluster.

![[Pasted image 20241022122020.png]]
Each node runs the kube-proxy component. Each node needs a network proxy component to ensure that the Service API and associated behaviors are available in the cluster. 

The control plane's components make global decisions regarding the cluster. They also handle detecting and responding to cluster events (ex. unsatisfied fields).

### kube-scheduler

Control plane component that watches for newly created Pods without a assigned node, and selects a node for them to run on.
### kube-controller-manager

Control plane component that runs the controller processes. 

Types of different controllers:
- **Node**
	- Responsible for noticing and responding when nodes go down
- **Job**
	- Watches for Job objects that represent one-off tasks, then creates Pods to run those tasks to completion
- **EndpointSlice**
	- Populates EndpointSlice objects to provide a link between Services & Pods
- **ServiceAccount**
	- Creates default ServiceAccounts for new namespaces

### cloud-controller-manager

Control plane component that embeds cloud-specific control logic.

Allows users to link their cluster into their cloud provider's API.

Separates out the components that interact with that cloud platform **from** components that only interact with your cluster.

Types of different controllers:
- **Node**
	- Checks the cloud provider to determine if a node has been deleted in the cloud after it stops responding
- **Route**
	- Sets up routes in the underlying cloud infrastructure
- **Service**
	- Creates, updates, and deletes cloud provider load balancers

### Node Components

- **kubelet**
	- Agent on each node that ensures PodSpecs are running
- **kube-proxy (optional)**
	- Network proxy on each node that maintains network rules
- **Container runtime**
	- Manages execution and lifecycle of containers within environment

### Variations

- Traditional Deployment
	- Control plane components run directly on dedicated VMs 
- Static Pods
	- Control plane components are deployed as static Pods
- Self-hosted
	- Control plane runs as Pods within the cluster itself

## Nodes

Kubernetes runs a workload by placing containers into Pods to run on **Nodes**.

A node is a VM (or physical) in the cluster that contains the services necessary to run Pods (managed by the control plane).

**Example Manifest of a Node**
```json
{
  "kind": "Node",
  "apiVersion": "v1",
  "metadata": {
    "name": "10.240.79.157",
    "labels": {
      "name": "my-first-k8s-node"
    }
  }
}
```

Kubernetes creates a Node object internally, then checks that a **kubelet** has registered to the API server that matches metadata.name field (must be unique).

If all services necessary are running, then the Pod is **eligible** to run.

### Node Controller

Control plane component that manages various aspects of nodes.

First, the node controller assigns a **CIDR block** to the node when its registered. Second, the node controller checks its internal list of nodes is up to date with the **cloud** provider's list of available machines.

Lastly, the node controller **monitors** the health of nodes (default: 5 second intervals)

Node objects track information about the Node's resource capacity.

## Communication between Nodes & The Control Plane

Kubernetes uses a "hub-and-spoke" API **pattern**. There are 2 primary communication paths from the control plane to the nodes. 

The first path is from the API server to the **kubelet** process (which runs on each node in the cluster).

The second path is from the API server to any node, pod, or service through the API server's **proxy** functionality.
 
**Kubernetes supports SSH tunnels.**

## Controllers

In Kubernetes, controllers are **control loops** (non-terminating loops that regulate the state of a system) that request changes where needed.

A controller tracks at least one **resource type** and are responsible for making the current state come closer to that desired state.

### Job Controller

The job controller is a **built-i**n controller utilizing the cluster API server. 

**Job** runs a Pod (or multiple) to carry out a task and then stop. It ensures that any new tasks inside of your cluster are running the **right number** of Nodes on any Pods or the container itself.

### Direct Control

In contrast with Job, some controllers need to make changes to things outside of the cluster.

For example, if a user utilizes a control loop to ensure there is enough Nodes in the cluster, then the controller **needs something outside** the current cluster to setup new Nodes when needed.

Controllers that interact with external state, find their desired state from the API server, then communicate **directly** with an **external system** to bring the current state closer in line.

Kubernetes utilizes tons of controllers that each manage a particular aspect of cluster state. 

## Cloud Controller Manager

Cloud infrastructure technologies allow users to run Kubernetes on public, private, and hybrid clouds.

The cloud-controller-manager is a control plane that embeds cloud-specific control logic.

![Pasted image 20241022104351.png](app://a17801c3b83c5b5a3f0cb5343c61835f4cbe/Users/tylerlanier/Documents/Obsidian/Pasted%20image%2020241022104351.png?1729608231198)

### Node Controller

The node controller is **responsible** for **updating** Node objects when **new** servers are created in the cloud infrastructure.

It **obtains** new **information** about the hosts running inside the tenancy with the cloud provider.

The node controller performs the following functions:
- Updates Node objects with the corresponding server's UID from API
- Annotating/Labelling the Node object with cloud-specific information
- Obtains the node's hostname and network addresses
- Verifies the node's health

### Route Controller

The route controller is responsible for **configuring** routes in the cloud so containers on **different** nodes inside the cluster can **communicate**.

### Service Controller

 Services **integrate** with **cloud** infrastructure components including managed load balances, IP addresses, and network packet filtering.

## Garbage Collection

**Garbage Collection** is a collective term for the various mechanisms Kubernetes uses to clean up cluster resources.

A majority of objects are linked together through **owner references** (different from labels/selectors).

Owner references tell the control plane which objects are **depending** on others, thus giving the **opportunity** to clean up related resources before **deleting** an object.

**Cross-namespace owner references are disallowed by design.**

### Cascading Deletion

Kubernetes checks and deletes objects that no longer have owner references.

Different types of deletion:
- **Foreground**
	- Owner object enters **deletion in progress** state, then controller deletes dependents. After deleting all the dependent objects, the controller deletes the owner object
- **Background**
	- API deletes owner object **immediately** and garbage collector controller cleans up the dependent objects in the background

The **kubelet** performs garbage collection on unused images and containers every minute.

Disk usage above the configured `HighThresholdPercent` value triggers garbage collection, which deletes images in order based on the last time they were used, starting with the oldest first. The kubelet deletes images until disk usage reaches the `LowThresholdPercent` value.

# Workloads

A workload is an **application** (made up of one or more components) that runs inside a set of **Pods** (containers).

Pods have a **defined lifecycle**, once a Node has a **critical** fault, **all** the pods on that node fail.

By utilizing **workload resources**, you can **automate** the process of each Pod by **configuring** the controllers.

Different types of workloads:
- **Deployment/ReplicaSet**
	- Manages stateless application workloads in the Cluster
- **StatefulSet**
	- Allows users to track multiple related Pods that track the state
- **DaemonSet**
	- Defines Pods & provides local facilities to nodes 
- **Job/CronJob**
	- Provides various methods to define tasks

## Pods

**Smallest** deployable units of computing possible in Kubernetes.

Pods are a group of **multiple** containers with shared **storage** & network resources (ran in shared context).

A Pod models multiple application-specific containers that are tightly coupled.

**Example Manifest of a Pod**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```

**Pods are created using workload resources, such as Deployment or Job.** 

Pods utilizes a controller for the resource, that handles replication, rollout and automatic healing (in case of Pod failure).

**Example Manifest of a Pod using Job**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hello
spec:
  template:
    # This is the pod template
    spec:
      containers:
      - name: hello
        image: busybox:1.28
        command: ['sh', '-c', 'echo "Hello, Kubernetes!" && sleep 3600']
      restartPolicy: OnFailure
    # The pod template ends here
```


**Modifying the pod template or switching to a new pod template has no direct effect on the Pods that already exist.**

### Pod Networking

Each Pod is assigned a **unique** IP address for each **address family**.

Every container in a Pod **shares** the network namespace, **including** the IP address/network ports (communicate using `localhost`).

When containers in a Pod **communicate** with **outside entities**, they must coordinate how they use the shared network resources (such as **ports**).

### Static Pods

**Static Pods** are managed directly by the **kubelet daemon** on a specific node (without the API observing).

Static Pods are always bound to one Kubelet on a node, allowing it to run a self-hosted control plane.

### Pods with Multiple Containers

Pods support **multiple** cooperating processes (as containers) that form a **cohesive** unit of service.

The containers **share** resources and dependencies, **communicate** with one another, and **coordinate** when/how they are terminated.

Ways Pods in a Kubernetes cluster are used:
- **Single Container**
	- A "wrapper" around a single container (most common)
- **Multiple Containers**
	- Encapsulates an application to form a cohesive unit of service

![[Pasted image 20241023123057.png]]

## Pod Lifecycle

Pods are considered to be relatively **ephemeral**, following a **defined** lifecycle.

If a Node dies, the Pods running on that node are **marked** for deletion.

While a Pod is running, the kubelet can **restart** containers to handle faults.
Within a Pod, K8 tracks different states of containers and **determines** what actions to **ensure** the Pod is healthy once more.

Pods are **binding**, assigning their scheduled lifetime **once** on a specific node.
A Pod is **terminated** once a stopped.

If a container **fails** however, K8 might try to **restart** that specific container. Although, if a Pod fails a specific way, it will **not** be attempted to heal and is **deleted**.

Through **higher-level abstraction** (controller), a Pod is replaced by a near-identical new Pod.

Phases of Pods:
- **Pending**
	- Pod is accepted but the containers have not been setup yet
- **Running**
	- Pod has been bounded to a Node and containers are created
- **Succeeded**
	- All containers in Pod have terminated in success
- **Failed**
	- All containers in Pod have terminated due to failure
- **Unknown**
	- Typically occurs due to communicating with the node where the Pod should be running

States of Pods:
- **Waiting**
	- Runs operations required for startup
- **Running**
	- Executing without issues
- **Terminated**
	- Ran to completion or failure

## Pod Conditions and Policies

Kubernetes manages container failures within Pods using `restartPolicy` defined in the Pod `spec`.

This policy determines how K8 reacts to containers exiting due to errors in a sequence:

- **Initial Crash**
	- Attempts an immediate restart
- **Repeated Crashes**
	- Applies an exponential backoff delay for subsequent restarts
- **CrashLoopBackOff**
	- Backoff delay mechanism is currently in affect for given container
- **Backoff Reset**
	- If container runs successfully for a certain duration, it resets the delay

A pod's`restartPolicy` field may contain the following:
- `Always`: Automatically restarts the container after any termination
- `OnFailure`: Only restarts the container if it exits with an error 
- `Never`: Does not automatically restart the terminated container

**PodConditions** determined through **PodStatus** are managed through the following:
- `PodScheduled`: the Pod has been scheduled to a node
- `PodReadyToStartContainers`: the Pod sandbox has been successfully created and networking configured
- `ContainersReady`: all containers in the Pod are ready
- `Initialized`: all [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) have completed successfully
- `Ready`: the Pod is able to serve requests and should be added to the load balancing pools of all matching Services

**Example Manifest of Pod Readiness**
```yaml
kind: Pod
...
spec:
  readinessGates:
    - conditionType: "www.example.com/feature-1"
status:
  conditions:
    - type: Ready                              # a built in PodCondition
      status: "False"
      lastProbeTime: null
      lastTransitionTime: 2018-01-01T00:00:00Z
    - type: "www.example.com/feature-1"        # an extra PodCondition
      status: "False"
      lastProbeTime: null
      lastTransitionTime: 2018-01-01T00:00:00Z
  containerStatuses:
    - containerID: docker://abcd...
      ready: true
...
```

## Pod Network

After a Pod is scheduled on a node, it is admitted by the kubelet to have any required **storage** volumes mounted.

Working with [Container runtime interface (CRI)](https://kubernetes.io/docs/concepts/architecture/#container-runtime), it sets up a runtime sandbox and configures networking for the Pod.

### Probes

`livenessProbe` indicates whether the container is **running**. If failed, the container is killed, and subjected to the **restart policy**.

`readinessProbe` indicates whether the container is **ready to respond** to requests. If failed, the endpoints controller removes the Pod's IP address from the endpoints of all Services (that match the pod).

`startupProbe` indicates whether the application within the **container is started**.

### Termination

Pods represent processes **running** on nodes in the cluster. It's important to allow those processes to **gracefully** terminate when they are no longer needed (rather than being **abruptly** stopped).

## Workload Management

**Example Deployment using `ReplicaSet`**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
**ReplicaSet's purpose is to maintain a stable set of replicated Pods running at any time.**


**Example Manifest of StatefulSets**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  selector:
    matchLabels:
      app: nginx # has to match .spec.template.metadata.labels
  serviceName: "nginx"
  replicas: 3 # by default is 1
  minReadySeconds: 10 # by default is 0
  template:
    metadata:
      labels:
        app: nginx # has to match .spec.selector.matchLabels
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: nginx
        image: registry.k8s.io/nginx-slim:0.24
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "my-storage-class"
      resources:
        requests:
          storage: 1Gi
```
**Like deployments, StatefulSets manage Pods that are based on an identical container spec.**

**Example Manifest of a DaemonSet**
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd-elasticsearch
  namespace: kube-system
  labels:
    k8s-app: fluentd-logging
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      tolerations:
      # these tolerations are to have the daemonset runnable on control plane nodes
      # remove them if your control plane nodes should not run pods
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      containers:
      - name: fluentd-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      # it may be desirable to set a high priority class to ensure that a DaemonSet Pod
      # preempts running Pods
      # priorityClassName: important
      terminationGracePeriodSeconds: 30
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
```
**DaemonSets ensure that all Nodes run a copy of a Pod.**

**Example Manifest of Job**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl:5.34.0
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
  backoffLimit: 4
```
**A Job creates one or more Pods that will continuously retry execution of Pods until a specific number of them are terminated.**

**Example Manifest of a CronJob**
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox:1.28
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```
**Cronjob is meant for performing regular scheduled actions such as backups.**

# Services, Load Balancing, and Networking

## Kubernetes Network Model

1. Each Pod in a cluster gets its own unique cluster-wide IP address
	- A pod has its own **private network namespace** (which is shared by all of the containers within the Pod)
2. The Pod Network (or cluster network) handles communication between pods.
	- All pods can communicate with all other pods, wether they are on the same node or different nodes (**without** the use of proxies or NAT)
	- Agens on a node (daemons or kubelet) can communicate with all pods on that node
3. The S**ervice API** lets you **provide** a **stable** IP address/hostname for a implemented service by **backend** pods
	- K8 automatically manages **EndpointSlice** objects to provide information about pods currently backing a Service
	- A service proxy implementation monitors the set of **Service/EndpointSlice** objects and programs the data plane to route traffic to its backends (to intercept or rewrite packets)
4. The **Gateway API** (or Ingress) allows users to make Services accessible to clients outside the cluster
5. **NetworkPolicy** allows users to control traffic between pods and the outside world

## Service

A method for exposing a network application that is running as multiple Pods in the cluster.

Each Service object defines a logical set of endpoints along with a policy about how to make those pods accessible.

**Manifest of a Service**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

**Manifest of a Port Specification**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: proxy
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
      - containerPort: 80
        name: http-web-svc

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app.kubernetes.io/name: proxy
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc
```
**Works for mixtures of Pods in the Service using a single configured name, with the same network protocol available via different ports.**

### Endpoints

An **Endpoints** defines a list of network endpoints.

**Example Manifest of Multi-port Services**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 9376
    - name: https
      protocol: TCP
      port: 443
      targetPort: 9377
```

### Service Types

- **ClusterIP**
	- Exposes the Service on a cluster-internal IP, making the value only reachable from within the cluster (can expose Service publicly using Ingress/Gateway)
- **NodePort**
	- Exposes the Service on each Node's IP at a static port
- **LoadBalancer**
	- Exposes the Service externally using an external load balancer
- **ExternalName**
	- Maps the Service to the contents of the `externalName` field, mapping the configures to the cluster's DNS server to return a `CNAME` record with the external hostname value (no proxying is setup for this)

## Ingress

Terminologies:
- **Node**
	- A worker machine
- **Cluster**
	- A set of Nodes that run containerized applications
- **Edge Router**
	- A router that enforces the firewall policy in the cluster (ex. a gateway)
- **Cluster Network**
	- A set of links, logical/physical, that facilitate communication within a cluster
- **Service**
	- Identifies a set of Pods using label selectors

**Ingress** exposes HTTP/HTTPS routes from outside the cluster to **services** within the cluster (traffic routing).

![[Pasted image 20241023140943.png]]

Allows for **externally-reachable URLs**, load balance traffic, terminate SSL/TLS, and offer name-based virtual hosting.

**Example Manifest of an Ingress Resource**
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

### Types of Ingress

**Simple fanout**  routes traffic. from a single IP address to more than one Service, based on the HTTP URL being requested. 

![[Pasted image 20241023141236.png]]


**Name-based virtual hosting** supports routing HTTP traffic to multiple host names at the same IP address.

## Gateway API

Makes network services **available** by using extensible, **role-oriented**, protocol-aware configuration mechanism. 

### Design Principle

Architecture of Gateway API:
- R**ole-oriented**: Gateway API kinds are modeled after organizational roles that are responsible for managing K8 service networking
	- **Infrastructure Provider**: Manages infrastructure that allows multiple isolated clusters to serve multiple tenants
	- **Cluster Operator**: Manages clusters (typically concerned with policies, network access, and application permissions)
	- **Application Developer**: Manages an application running in a cluster (typically concerned with application-level and Service composition)
- **Portable**: Specifications are defined as **custom resources**
- **Expressive**: Supports functionality for common traffic routing use cases
- **Extensible**: Allows for  custom resources to be linked at various layers of the API


### Resource Model

- **GatewayClass**
	- Defines a set of gateways with common configurations (managed by a controller that implements the class)
- **Gateway**
	- Defines an instance of traffic handling infrastructure (cloud load balancer)
- **HTTPRoute**
	- Defines HTTP-specific rules for mapping traffic from a Gateway listener to a representation of backend network endpoints

![[Pasted image 20241023141958.png]]

**Manifest of minimal GatewayClass**
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: example-class
spec:
  controllerName: example.com/gateway-controller
```

**Gateway** describes an instance of traffic handling infrastructure, defining a network endpoint that is used for processing traffic filtering for backends.

### Request Flow

![[Pasted image 20241023142337.png]]

## EndpointSlices


**EndpointSlice** contains references to a set of network endpoints.

The control plane **automatically** creates EndpointSlices for any Service that has a selector specified, including references to all the Pods that match the Service selector.

**Example Manifest of EndpointSlice Object**
```yaml
apiVersion: discovery.k8s.io/v1
kind: EndpointSlice
metadata:
  name: example-abc
  labels:
    kubernetes.io/service-name: example
addressType: IPv4
ports:
  - name: http
    protocol: TCP
    port: 80
endpoints:
  - addresses:
      - "10.1.2.3"
    conditions:
      ready: true
    hostname: pod-1
    nodeName: node-1
    zone: us-west2-a
```

Each EndpointSlice has a **set of ports** that applies to all endpoints within the resource. 

# Cluster Administration

## Cluster Networking

Kubernetes **simplifies** the process of dynamic port allocation. 

Kubernetes clusters **require** to allocate **non-overlapping** IP addresses for Pods, Services and Nodes, from a range of available addresses configured in the following components:
- The **network plugin** is configured to assign IP addresses to **Pods**.
- The **kube-apiserver** is configured to assign IP addresses to **Services**.
- The **kubelet** or the cloud-controller-manager is configured to assign IP addresses to **Nodes**.

![[Pasted image 20241023144615.png]]

## Logging Architecture



Application logs help users understand what is **occurring** inside the application. 

Cluster logs should have their own **separate** storage/lifecycle from the rest of the containers.

Cluster-level logging architectures **require** a separate backend to store, analyze, and query logs (not provided a native storage solution).

![[Pasted image 20241023144833.png]]

**Kubelet** is responsible for **rotating** container logs and managing the logging directory structure (sends information to container runtime using CRI).

![[Pasted image 20241023144938.png]]
**Common approaches for cluster-level logging natively:** 
- Use a node-level logging agent that runs on every node.
- Include a dedicated sidecar container for logging in an application pod.
- Push logs directly to a backend from within an application.

![[Pasted image 20241023145136.png]]
![[Pasted image 20241023145145.png]]
**Node-level agents inside the cluster pick up on log streams automatically without any further configuration.**


# Common Troubleshooting

## Troubleshooting Applications

### Debugging Pods

**First step** is to check the **current state** of the Pod and **recent events**:
```shell
kubectl describe pods ${POD_NAME}
```

#### Pending

If a Pod is stuck in `Pending` , it **can not** be **scheduled** onto a node. Typically this is due to **insufficient resources**.

From the **output** of the **previous command** look for `kubectl describe ...`, this will describe the issue:

- **[You don't have enough resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)**
	- Exhausted the supply of CPU or Memory in the cluster, need to delete Pods, adjust resource requests, or add new nodes to the cluster.
- **You are using `hostPort`**:
	- Binding a Pod to a `hostPort` limits the number of places that pod can be scheduled. 
	- In most cases, `hostPort` is unnecessary, try using a Service object to expose the Pod. If you do require `hostPort` then you can only schedule as many Pods as there are nodes in your Kubernetes cluster.

#### Waiting

If a Pod is stuck in `Waiting`, it has been scheduled for a worker node but cannot run on the machine. Again, the command `kubectl describe ...` should be informative.

There are a few things to check:
- Make sure that the name of the image correct.
- Is the image pushed to the registry?
- Try to manually pull the image to see if the image can be pulled. For example, if you use Docker on own PC, run `docker pull <image>`.

#### Terminating

If a Pod is stuck in `Terminating`, a deletion has been issued for the Pod, but the control plane is unable to delete the Pod object.

Typically, this occurs if the Pod has a **finalizer** and there is an **admission webhook** installed in the cluster that prevents the control plane from removing the finalizer.

Identify if the cluster has any **ValidatingWebhookConfiguration** or **MutatingWebhookConfiguration** that target `UPDATE` operations for `pods` resources.

### Debugging Services

To view what a Pod running in the cluster sees, run an **interactive busybox** Pod:
```shell
kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox sh
```

You can do this on a running Pod as well:
```shell
kubectl exec <POD-NAME> -c <CONTAINER-NAME> -- <COMMAND>
```

You can confirm the Pods are running:
```shell
kubectl get pods -l app=hostnames
```

Also confirm the Pods are serving (list of Pod IPs)
```shell
kubectl get pods -l app=hostnames \
    -o go-template='{{range .items}}{{.status.podIP}}{{"\n"}}{{end}}'
```

If you are not getting any response, the Pods might be unhealthy or not listening on the right port. Try checking either `kubectl logs` or `kubectl exec`.

Check for Services existing
```shell
kubectl get svc hostnames
```

Check if a Service is on the right DNS name
```shell
nslookup hostnames
```

If failed, the Pods and Service might be on different namespace
```shell
nslookup hostnames.default
```

Enable cross-namespace name on application
```shell
nslookup hostnames.default.svc.cluster.local
```

Can try from Node in the cluster
```shell
nslookup hostnames.default.svc.cluster.local 10.0.0.10
```

Check to see if ``/etc/resolv.conf`` file in the Pod is correct
```shell
cat /etc/resolv.conf
```

Confirm the kube-proxy is running
```shell
ps auxw | grep kube-proxy
```


### Determining Reason for Pod Failure

First, ensure that the **`kubectl` command-line tool** is configured to communicate with the cluster.

Display Information about a Pod
```shell
kubectl get pod termination-demo
```

Detailed variation
```shell
kubectl get pod termination-demo --output=yaml
```

Template for multi-container Pod
```shell
kubectl get pod multi-container-pod -o go-template='{{range .status.containerStatuses}}{{printf "%s:\n%s\n\n" .name .lastState.terminated.message}}{{end}}'
```

### Debugging Running Pods

Assumption that Pods are currently running and scheduled.

Retrieve more information about each of the pods using `kubectl describe pod`.
```shell
kubectl describe pod nginx-deployment-67d4bdd6f5-w6kd7
```

Examine Pod Logs
```shell
kubectl logs ${POD_NAME} ${CONTAINER_NAME}
```

Previously crashed Pods
```shell
kubectl logs --previous ${POD_NAME} ${CONTAINER_NAME}
```

Debugging Container Exec (windows/linux images with pre-built utilities)
```shell
kubectl exec ${POD_NAME} -c ${CONTAINER_NAME} -- ${CMD} ${ARG1} ${ARG2} ... ${ARGN}
```

## Troubleshooting Clusters

Ensure all your nodes are registered to the cluster
```shell
kubectl get nodes
```

Verify all Nodes are present and in `Ready` state (detailed overall health)
```shell
kubectl cluster-info dump
```

You can use `kubectl describe node` and `kubectl get node -o yaml` to retrieve detailed information about nodes.

```shell
kubectl describe node kube-worker-1
```
```shell
kubectl get node kube-worker-1 -o yaml
```

#### Control Plane nodes[](https://kubernetes.io/docs/tasks/debug/debug-cluster/#control-plane-nodes)

- `/var/log/kube-apiserver.log` - API Server, responsible for serving the API
- `/var/log/kube-scheduler.log` - Scheduler, responsible for making scheduling decisions
- `/var/log/kube-controller-manager.log` - a component that runs most Kubernetes built-in [controllers](https://kubernetes.io/docs/concepts/architecture/controller/), with the notable exception of scheduling (the kube-scheduler handles scheduling).


#### Worker Nodes[](https://kubernetes.io/docs/tasks/debug/debug-cluster/#worker-nodes)

- `/var/log/kubelet.log` - logs from the kubelet, responsible for running containers on the node
- `/var/log/kube-proxy.log` - logs from `kube-proxy`, which is responsible for directing traffic to Service endpoints

## Troubleshooting Kubectl

Check the current version is up-to-date
```shell
kubectl version
```

If you see `Unable to connect to the server: dial tcp <server-ip>:8443: i/o timeout`, instead of `Server Version`, you need to troubleshoot kubectl connectivity with your cluster.

The `kubectl` requires a `kubeconfig` file to connect to a Kubernetes cluster. The `kubeconfig` file is usually located under the `~/.kube/config` directory. Make sure that you have a valid `kubeconfig` file. If you don't have a `kubeconfig` file, you can obtain it from your Kubernetes administrator, or you can copy it from your Kubernetes control plane's `/etc/kubernetes/admin.conf` directory.

If you are using a Virtual Private Network (VPN) to access your Kubernetes cluster, make sure that your VPN connection is active and stable.

Check the if the API server's host is reachable by using `ping` command.

The Kubernetes API server only serves HTTPS requests by default. In that case TLS problems may occur due to various reasons, such as certificate expiry or chain of trust validity.

You can find the TLS certificate in the kubeconfig file, located in the `~/.kube/config` directory. The `certificate-authority` attribute contains the CA certificate and the `client-certificate` attribute contains the client certificate.

```shell
kubectl config view --flatten --output 'jsonpath={.clusters[0].cluster.certificate-authority-data}' | base64 -d | openssl x509 -noout -dates
```

```shell
kubectl config view
```