### Installing nginx ingress controller

Now, instead of using an IP, lets set up an ingress controller so we can use domain names.

I will be using helm to install this, if you havent installed helm go [here](https://helm.sh/docs/intro/install/)

The ingress controller i am using is [nginx ingress controller](https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-helm/)

There are two sources to install this, kubernetes community and nginx offical site. I prefer the community and have found the most success with it.


#### From Kubernetes [Community Docs](https://kubernetes.github.io/ingress-nginx/deploy/) (Preffered))

##### Option A - Helm

This is an all in one install / update solution that will place it all in ingress-nginx namespace

    helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace

You can check the setable values 

    helm show values ingress-nginx --repo https://kubernetes.github.io/ingress-nginx

##### Option B - Manual

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml


#### From Nginx [Official Site](https://docs.nginx.com/nginx-ingress-controller/)


##### Option A - Helm Via OCI Registry

The service will be deployed as my-release-nginx-ingress-controller, change my-release in the following command if you want to name it.

    helm install my-release oci://ghcr.io/nginxinc/charts/nginx-ingress --version 1.1.0

To uninstall (Replace my-release with whatever name you used.)

    helm uninstall my-release 


##### Option B - Helm Manually

Pull the chart

    helm pull oci://ghcr.io/nginxinc/charts/nginx-ingress --untar --version 1.1.0

Cd into folder

    cd nginx-ingress

Create nginx-ingress namespace

    kubectl create namespace nginx-ingress

Deploy the required resources into new namespace (?)

    kubectl -n nginx-ingress apply -f crds

Finally run helm install command

    helm install --namespace=nginx-ingress nginx-ingress .

Verifiy its running

    kubectl get pods -n nginx-ingress

#### Testing basic ingresss

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

#### Assigning DNS name to the ingresss

Go to wherever your CA is (Mine is cloudflare) and do the following.

- For more detail, you want to create an A record with your domain name (www.example.com) and have it point to the external IP.
- Then you can create a CNAME wild card (name would be *) and have it point to your domain name which will point any subdomains to www.example.com.

To test it, you can do the following which is sourced from part 4 [here](https://cert-manager.io/docs/tutorials/acme/nginx-ingress/)

Test Deployment

    kubectl apply -f https://raw.githubusercontent.com/cert-manager/website/master/content/docs/tutorials/acme/example/deployment.yaml

Test Service

    kubectl apply -f https://raw.githubusercontent.com/cert-manager/website/master/content/docs/tutorials/acme/example/service.yaml

Test Ingress, change the hosts values to your DNS name you redirected to earlier (www.example.com)

    kubectl create --edit -f https://raw.githubusercontent.com/cert-manager/website/master/content/docs/tutorials/acme/example/ingress.yaml

You should then be able to browse to this on the web, however it will give an insecure warning since we havent implemented secure certificates. We can use cert-manager for that.








## Upgrading

    helm upgrade ingress-nginx ingress-nginx --repo https://kubernetes.github.io
    /ingress-nginx --set tcp.22="gitlab/mygitlab-gitlab-shell:22" --namespace ingress-nginx