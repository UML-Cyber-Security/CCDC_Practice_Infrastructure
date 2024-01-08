# Overview

- The following creates a simple web app that is accessible via a domain name.
- It uses NGINX ingress controller and metalLB to accomplish this.
- The following yml files are referenced
  - ../Resources/Deployments/web-app-deployment-example.yml
  - ../Resources/Services/web-app-services-example.yml
  - ../Resources/Ingress/web-app-ingress-example.yml
  - ../Resources/IPAddressPools/web-app-IPAddressPool.yml
  - ../Resources/L2Advertisement/web-app-L2Advertisement.yml
- The names in the guide are slightly different, but it is self explanatory which one is which. If unsure, just match web-app-x with the Resource type in each of the file examples.


# Installing metallb

Enable strictARP here

    kubectl edit configmap -n kube-system kube-proxy 

or with a command to do the above

    kubectl get configmap kube-proxy -n kube-system -o yaml | \
    sed -e "s/strictARP: false/strictARP: true/" | \
    kubectl apply -f - -n kube-system

Now to install by manifests

    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml 

Now we need to configure IPAddressPool resource. Create a file called pool-1.yml and add the following contents (Adjust ip to what you want.) This is the IP range that will be accessible outside.

    apiVersion: metallb.io/v1beta1
    kind: IPAddressPool
    metadata:
      name: first-pool
      namespace: metallb-system
    spec:
      addresses:
      - 10.35.40.30-10.35.40.40

Make sure to apply this

    kubectl apply -f IPAddressPool.yml

Now we need to create an L2Advertisement resource. Create a file called l2-advertisement.yml or something. Make sure teh ipAddressPools at the bottom is the same name as the one you just created.

    apiVersion: metallb.io/v1beta1
    kind: L2Advertisement
    metadata:
      name: homelab-l2-advertisement
      namespace: metallb-system
    spec:
      ipAddressPools:
      - first-pool

Make sure to apply this

    kubectl apply -f L2Advertisement.yml

Okay, give it a try with a test webapp deployment. Toss this into a web-app-deployment.yml file,

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: web-app
      labels:
        app.kubernetes.io/name: web-app
    spec:
      replicas: 1
      selector:
        matchLabels:
          app.kubernetes.io/name: web-app
      template:
        metadata:
          labels:
            app.kubernetes.io/name: web-app
        spec:
          containers:
          - image: nginx
            name: web-app
            command: 
              - /bin/sh
              - -c
              - "echo 'welcome to my web app!' > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"
          dnsConfig:
                options:
                  - name: ndots
                    value: "2"

    ---

    apiVersion: v1
    kind: Service
    metadata:
      name: web-app
      labels:
        app.kubernetes.io/name: web-app
    spec:
      selector:
        app.kubernetes.io/name: web-app
      ports:
      - name: http
        port: 80
        protocol: TCP
        targetPort: 80
      type: LoadBalancer

Then apply it,

    kubectl apply -f web-app-deployment.yml

And test it.Get the EXTERNAL-IP of the service and then curl it.
    
    kubectl get svc web-app
    curl <EXTERNAL-IP> 

Now, instead of using an IP, lets set up an ingress controller so we can use domain names.

I will be using helm to install this, if you havent installed helm go [here](https://helm.sh/docs/intro/install/)

The ingress controller i am using is [nginx ingress controller](https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-manifests/)
Pull the chart

    helm pull oci://ghcr.io/nginxinc/charts/nginx-ingress --untar --version 1.0.2

Cd into folder

    cd nginx-ingress

Create nginx-ingress namespace

    kubectl create -n nginx-ingress

Deploy the required resources into new namespace

    kubectl -n nginx-ingress apply -f crds

Finally run helm install command

    helm install nginx-ingress .

Verifiy its running

    kubectl get pods -n nginx-ingress

Now, lets alter our deployment to use this new ingress tool

First edit web-app-deployment.yml and remove the line,

    type: LoadBalancer

Then, create a file called web-app-ingress.yml and add the following

    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: web-app
      annotations:
        kubernetes.io/ingress.class: "nginx"
    spec:
      rules:
      - host: web-app.home-k8s.lab
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web-app
                port:
                  number: 80

Apply this,

    kubectl apply -f web-app-ingress.yml

You can test this locally by adding the mapping to your /etc/hosts file. For example,
    
    10.35.40.31 web-app.home-k8s.lab

The IP you add above is from the following command and under EXTERNAL-IP, Look for the nginx-ingress-controller service,    
    
    kubectl get svc -n nginx-ingress

Finally,

    curl web-app.home-k8s.lab

If you want decided to remove everything.

    cd nginx-ingress
    helm uninstall nginx-ingress .
    kubectl delete all --all -n nginx-ingress
    kubectl delete all --all -n metallb-system
  
    
