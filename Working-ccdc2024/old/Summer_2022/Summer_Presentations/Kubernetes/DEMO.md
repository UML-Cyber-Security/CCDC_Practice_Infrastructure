# DEMO SCRIPT

## NAMESPACES

```bash
kubectl create namespace demo
```

## PODS

```bash
vim pod.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-nginx
  namespace: demo
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

```bash
kubectl create -f pod.yaml
```

```bash
kubectl delete pod -n demo demo-nginx && rm pod.yaml
```

## DEPLOYMENTS

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-webapp-deployment
  namespace: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: adalimayeu/webapp-color:latest
        ports:
        - containerPort: 80
        env:
        - name: COLOR
          value: pink
```

```bash
kubectl scale deployment demo-webapp-deployment -n demo --replicas=3
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-webapp-service
  namespace: demo
spec:
  type: NodePort
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30000
```

```bash
kubectl edit deployment demo-webapp-deployment -n demo
```
Change color

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-red-webapp
  namespace: demo
  labels:
    app: webapp
spec:
  containers:
  - name: webapp
    image: adalimayeu/webapp-color:latest
    ports:
    - containerPort: 80
    env:
    - name: COLOR
      value: red
```
Show load balancing

```bash
curl http://localhost:30000/
```

## DAEMONSETS
Puts a pod on every node

## JOBS

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: busybox-job
  namespace: demo
spec:
  backoffLimit: 1
  completions: 6
  parallelism: 2
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["/bin/sh","-c","sleep 10 && echo 'DONE'"]
      restartPolicy: Never
```

## CRONJOB
Job that is on a schedule

## CONFIGMAPS
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: demo-cm
  namespace: demo
data:
  KEY: VALUE
  FOO: BAR
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cm-demo-pod
  namespace: demo
spec:
  containers:
  - name: pod
    image: busybox
    command: ["sleep", "100000"]
    envFrom:
    - configMapRef:
        name: demo-cm
```

## Security Context
https://github.com/UML-Cyber-Security/ccdc2023/tree/k8s-presentation/Summer_Presentations/Kubernetes#security-context

## SERVICE ACCOUNT

```bash
kubectl create serviceaccount dashboard
```

## ROLE
Cluster Role vs. Role

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dashboard-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list", "create","delete"]
```

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: dashboard-sa-binding
subjects:
- kind: ServiceAccount
  name: dashboard
roleRef:
  kind: Role
  name: dashboard-role
  apiGroup: rbac.authorization.k8s.io
```


### TESTING

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dashboard
  labels:
    app: dashboard
spec:
  serviceAccountName: dashboard
  containers:
    - name: dashboard
      image: gcr.io/kodekloud/customimage/my-kubernetes-dashboard
      ports:
        - name: web
          containerPort: 8080
          protocol: TCP
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-dashboard-service
spec:
  type: NodePort
  selector:
    app: dashboard
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30001
```

## NETWORK POLICY
Go over what it does

## User Certificates
https://github.com/UML-Cyber-Security/ccdc2023/tree/k8s-presentation/Summer_Presentations/Kubernetes#certificates

## Components
https://github.com/UML-Cyber-Security/ccdc2023/tree/k8s-presentation/Summer_Presentations/Kubernetes#components
