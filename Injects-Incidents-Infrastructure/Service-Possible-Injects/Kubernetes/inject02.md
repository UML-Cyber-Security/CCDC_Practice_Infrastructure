# Service
Simple Static Web server hosted on Kubernetes that is accessible via ingress [Easy]

(If you know what you are doing)
**Time**: 15 minutes

(If you do not know what you are doing)
**Time**: 1 Hour

## Expectations 

- This is a continuation of inject 1, so everything there should be deployed
- The web server should now be accessible via a hostname "www.example.com" instead of an IP, they should provide this to us.
  - FYI, without certs at this stage you must put the IP and Hostname into your /etc/hosts file for it to resolve correctly, unless you have local DNS setup.
  - This can be acheived with something like nginx ingress controller, Traefik, etc

## Dependencies

- You could delete / edit one of the following peices and see if they notice,
  - Deployment itself
    - kubectl get deployments
    - kubectl edit deployments <name> --namespace=<namespace>
    - kubectl delete deployment --namespace=<namespace>
  - Service associated with it
    - kubectl get services
    - kubectl edit services --namespace=<namespace>
    - kubectl delete <service> --namespace=<namespace>
  - Change the label associated with the service and deployment so they do not properly match
  - Change the ingress host to something else and see if they notice (See below)
  - Anything further at this stage would be toxic

Ingress Alteration

kubectl get ingress --all-namespaces
kubectl edit ingress <one you want>

    spec:
    ingressClassName: nginx
    rules:
    - host: nexus-core.dev
        http:
        paths:
        - backend:
            service:
                name: kuard
                port:
                number: 80
            path: /
            pathType: Prefix
    tls:
    - hosts:
        - nexus-core.dev
        secretName: quickstart-example-tls

I could change host: nexus-core.dev to somethiong else to throw it off.

## Inject

In the previous task you successfully deployed the web server on an external IP address. We now want the clients to be able to access the web server with our domain name, therefore you need to find a way to use a domain to browse to the server instead of an IP Address.