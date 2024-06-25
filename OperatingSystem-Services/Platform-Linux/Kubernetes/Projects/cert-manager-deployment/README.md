# Deploying cert-manager

[toc]

## General Information

FYI, if you have already deployed metalLB (Or some other LoadBalancer) then cert-manager will automatically be assigned an external IP. Otherwise, you either need to assign a pool or deploy a Loadbalancer. This is out of scope currently.

Tutorial I am [following](https://cert-manager.io/docs/installation/helm/)


### Open Ports

## Known Requirements

- Deploying LoadBalancer 
- Assigning DNS name to the external IP (For example, via cloudflare I pointed my personal domain to the IP exposed for the nginx ingress.)
  - For more detail, you want to create an A record with your domain name (www.example.com) and have it point to the external IP.
  - The IP to point to is the external IP for the nginx ingress controller, check in the nginx-ingress namespace under services, or just get services from --all-namespaces and look for it.
  - Then you can create a CNAME wild card (name would be *) and have it point to your domain name which will point any subdomains to www.example.com.
- Deploying nginx ingress manager (Highly recommended to use kubernetes community guide, not offical )

## Installation


### Via Helm

Add helm repo

    helm repo add jetstack https://charts.jetstack.io

Update Helm

    helm repo update

Installing the required CRDS with kubectl

    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.crds.yaml

Installing cert-manager via helm (Instead of above command you can alternatively add the flag --set installCRDs=true)

    helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.13.3

You can add other flags for the customization like, check the docs for more info.

    --set prometheus.enabled=false \  # Example: disabling prometheus using a Helm parameter
    --set webhook.timeoutSeconds=4   # Example: changing the webhook timeout using a Helm parameter

### Setting up Issuer

Now we must deploy an Issuer. By default, issuers are per single namespace, but you can do a cluster-wide one with ClusterIssuer.

This is the point that things can be very, very different.

#### Cloudflare

Get your api token and create the following secret (Also in the yaml files in this folder)

    apiVersion: v1
    kind: Secret
    metadata:
      name: cloudflare-api-token-secret
    type: Opaque
    stringData:
      api-token: <API Token>

Then deploy a local issuer (This is only available in the deployed namespace)

    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
      name: example-issuer
    spec:
      acme:
          # The ACME server URL
        server: https://acme-v02.api.letsencrypt.org/directory
          # Email address used for ACME registration
        email: <your@email>
          # Name of a secret used to store the ACME account private key (Auto-created, name what you want, must match ingress issuer)
        privateKeySecretRef:
          name: letsencrypt-staging
        # Enable the DNS-01 challenge provider
        solvers:
        - dns01:
            cloudflare:
              apiTokenSecretRef:
                name: cloudflare-api-token-secret
                key: api-token

If you wanted to create a clusterissuer (Available in all namespaces) all you need to do is change 

    kind: Issuer
      to
    kind: ClusterIssuer

Also, if you changed it to a ClusterIssuer, you must change the annotation on any ingress you make from,

    cert-manager.io/issuer: "letsencrypt-staging"

to,

    cert-manager.io/clusterissuer: "letsencrypt-staging"

### Testing

Here is an example service

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: kuard
    spec:
      selector:
        matchLabels:
          app: kuard
      replicas: 1
      template:
        metadata:
          labels:
            app: kuard
        spec:
          containers:
          - image: gcr.io/kuar-demo/kuard-amd64:1
            imagePullPolicy: Always
            name: kuard
            ports:
            - containerPort: 8080
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: kuard
    spec:
      ports:
      - port: 80
        targetPort: 8080
        protocol: TCP
      selector:
        app: kuard

An example ingress (Change host: to whatever your domain is)

    apiVersion: networking.k8s.io/v1 
    kind: Ingress
    metadata:
      name: kuard
      annotations:
        cert-manager.io/issuer: "letsencrypt-staging"

    spec:
      ingressClassName: nginx
      tls:
      - hosts:
        - example.example.com
        secretName: quickstart-example-tls
      rules:
      - host: example.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: kuard
                port:
                  number: 80

You can browse to it to connect, but a good quick check is with the following, where you should see the domain you set and the IP of the loadbalancer.

    kubectl get ingress


## Troubleshooting commands

Go to the cert-manager documentation for indepth troubleshooting, these are just common commands I used during troubleshooting to track the issue.

    kubectl get ingress

    kubectl get certificates

    kubectl get certificatesrequests

    kubectl get challenges

## Troubleshooting Topics

### Secrets in wrong place

A large issue I ran into when creating ingress for these was the api-token secret was deployed in the default namespace, and was unnaccessible to the cert-manager namespace. Ensure you deploy it in the cert-manager namespace.

### ACME Issues

Another issue was when deploying longhorn it was set to not use ssl, so the verification never made it through, hence the certificate never finished issuing. Ensure you are not blocking TLS in the ingress annotations. My example looked like this, where prevent from redirecting to HTTPS was true, and I had to add the ssl-redirect options as well.

    annotations:
        # type of authentication
        nginx.ingress.kubernetes.io/auth-type: basic
        # prevent the controller from redirecting (308) to HTTPS
        kubernetes.io/ingress.allow-http: "false"
        nginx.ingress.kubernetes.io/ssl-redirect: 'true'
        nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
        # name of the secret that contains the user/password definitions
        nginx.ingress.kubernetes.io/auth-secret: basic-auth
        # message to display with an appropriate context why the authentication is required
        nginx.ingress.kubernetes.io/auth-realm: 'Authentication Required '
        # custom max body size for file uploading like backing image uploading
        nginx.ingress.kubernetes.io/proxy-body-size: 10000m
        # Certmanager
        cert-manager.io/cluster-issuer: "development-issuer"


### Using kubernetes.io/tls-acme: "true"

This annotation is used in other deployments to automatically deploy certificates. If you need to use it you can update the current deployment with the below command. Make sure to change the defaultIssuerName to your cluster issuer.

    helm upgrade cert-manager jetstack/cert-manager --namespace cert-manager --version v1.13.3 --set ingressShim.defaultIssuerName=development-issuer --set ingressShim.defaultIssuerKind=ClusterIssuer --set ingressShim.defaultIssuerGroup=cert-manager.io