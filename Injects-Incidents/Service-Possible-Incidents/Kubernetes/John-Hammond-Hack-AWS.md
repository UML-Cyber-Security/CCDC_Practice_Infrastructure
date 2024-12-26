## some new kubectl commands that are interesting

Check what service account you are under

    kubectl auth whoami

Check your permissions

    kubectl auth can-i --list

Grab / View Secrets

    kubectl get secrets

    kubectl get secret <name> -o yaml

Decrypt a standard kubernetes base64 secret

    base64 -d <<< '<secret>'

## Some things to keep in mind.

If you prevented the listing of secrets, but still allowed getting, there is a risk, they cant list the secrets but there are other means of getting the name. If they are able to get pods, they can check if the pod has imagePullSecrets in it, then use get for that secret to get the data. This secret is most likely used to pull a container off a registry, where they can access internal usage / data.