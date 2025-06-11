# Updating the Contents of an Nginx Webpage in Kubernetes

## TOC
- [Updating the Contents of an Nginx Webpage in Kubernetes](#updating-the-contents-of-an-nginx-webpage-in-kubernetes)
  - [TOC](#toc)
  - [Step 1: Create a ConfigMap with the New HTML Content](#step-1-create-a-configmap-with-the-new-html-content)
  - [Step 2: Mount the ConfigMap as a Volume in the Nginx Pod](#step-2-mount-the-configmap-as-a-volume-in-the-nginx-pod)
  - [Step 3: Verify the Updated Webpage](#step-3-verify-the-updated-webpage)
  - [Notes](#notes)


## Step 1: Create a ConfigMap with the New HTML Content

1. Create a new HTML file on your local machine, for example, `index.html`:

   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title>Welcome to My Custom Nginx Page</title>
   </head>
   <body>
       <h1>Hello, Mr. Chris</h1>
       <p>Custom Nginx page through Kubernetes.</p>
   </body>
   </html>
   ```

2. Create a ConfigMap in Kubernetes to hold your custom HTML content:

   ```sh
   kubectl create configmap nginx-html --from-file=index.html
   ```

   This command creates a ConfigMap named `nginx-html` that contains the `index.html` file.

## Step 2: Mount the ConfigMap as a Volume in the Nginx Pod

1. Update your Nginx Deployment to mount the ConfigMap as a volume. Modify your `nginx-deployment.yaml` file:

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
           # Here
           volumeMounts:
           - name: nginx-html
             mountPath: /usr/share/nginx/html
             subPath: index.html
     volumes:
     - name: nginx-html
       configMap:
         name: nginx-html
   ```

2. Apply the updated Deployment:

   ```sh
   kubectl apply -f nginx-deployment.yaml
   ```

   This step will update your Nginx pods to serve the custom `index.html` from the ConfigMap.

## Step 3: Verify the Updated Webpage

1. Access the Nginx webpage as before using your node's IP and NodePort or the Ingress setup.

2. You should see the updated content on your webpage, displaying the custom HTML you provided.

## Notes

- **ConfigMap Limitations**: ConfigMaps are intended for small configuration data. If your HTML content is extensive, consider using a PersistentVolume to store your web content instead.
- **PersistentVolume Approach**: If you want to serve more complex web content, consider creating a PersistentVolume and PersistentVolumeClaim, and then mount that volume in your Nginx pods.
- **ConfigMap**: A way to manage and share configuration data with your applications in Kubernetes without hardcoding the information inside the application itself. Akin to a more specific settings page for your deployment. Useful for having different settings for different enviornments, and being able to quickly swap out settings.
- *This doc was taken from my notes, so there are small choices I had placed to help me better understand.*