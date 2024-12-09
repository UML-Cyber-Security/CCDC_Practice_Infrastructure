
# Deploying an Nginx Website on Kubernetes

## TOC
- [Deploying an Nginx Website on Kubernetes](#deploying-an-nginx-website-on-kubernetes)
  - [TOC](#toc)
  - [Step 1: Create a Deployment for Nginx](#step-1-create-a-deployment-for-nginx)
  - [Step 2: Expose Nginx via a Service](#step-2-expose-nginx-via-a-service)
  - [Step 3: Access the Nginx Website Externally](#step-3-access-the-nginx-website-externally)
  - [Step 5: Verify External Access](#step-5-verify-external-access)


## Step 1: Create a Deployment for Nginx
Create a Deployment resource to run an Nginx container. This will ensure that an Nginx pod is always running.

1. Create a YAML file named `nginx-deployment.yaml`:

    ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-deployment
   spec:
     replicas: 2
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
           image: nginx:latest
           ports:
           - containerPort: 80
   ```

2. Apply the Deployment using `kubectl`:

   ```sh
   kubectl apply -f nginx-deployment.yaml
   ```

## Step 2: Expose Nginx via a Service
To make the Nginx deployment accessible within the Kubernetes cluster, create a Service.

1. Create a YAML file named `nginx-service.yaml`:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: nginx-service
   spec:
     selector:
       app: nginx
     ports:
       - protocol: TCP
         port: 80
         targetPort: 80
     type: NodePort
   ```

2. Apply the Service using `kubectl`:

   ```sh
   kubectl apply -f nginx-service.yaml
   ```

3. Verify that the Service has been created:

   ```sh
   kubectl get services
   ```

   Note the `NodePort` assigned by Kubernetes.

## Step 3: Access the Nginx Website Externally
To access the Nginx website from outside the Kubernetes cluster, you need to access the `NodePort` on one of your cluster's nodes.

1. Determine the external IP address of one of your nodes (you can use `kubectl get nodes -o wide` to see the IPs).

2. Access the Nginx website in your browser or using `curl` by visiting:

   ```
   http://<node-ip>:<node-port>
   ```
## Step 5: Verify External Access
Visit the domain or IP specified in your Ingress resource. You should see the default Nginx welcome page.

*This doc was taken from my notes, so there are small choices I had placed to help me better understand.*