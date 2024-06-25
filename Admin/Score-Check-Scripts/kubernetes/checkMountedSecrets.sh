#!/bin/bash

# This is not necessarily a health check, but useful for telling what secrets are mounted in pods
# to check insecure mountings

# Grab all pod names
pods=$(kubectl get pods --no-headers -o custom-columns=":metadata.name,:metadata.namespace")

# Split the string into an array of lines
readarray -t pods_array <<<"$pods"

# Iterate through the array and process each pod
for ((i = 0; i < ${#pods_array[@]}; i++)); do
  # Extract name and namespace from the line
  line=${pods_array[i]}
  read -r name namespace <<<"$line"

  # Check if name and namespace are not empty
  if [[ -n "$name" && -n "$namespace" ]]; then
    # Check if the pod is running
    if kubectl get pod "$name" -n "$namespace" &>/dev/null; then
      # Check if the directory exists in the container
      if kubectl exec "$name" -n "$namespace" -- ls /var/run/secrets/kubernetes.io/serviceaccount &>/dev/null; then
        mounted_secrets=$(kubectl exec "$name" -n "$namespace" -- ls /var/run/secrets/kubernetes.io/serviceaccount)
        echo "Mounted secrets in $name ($namespace):"
        echo ""
        echo "$mounted_secrets"
        echo "+++++++"
      else
        #echo "Directory not found in $name ($namespace)"
        true
      fi
    else
      echo "Pod $name not found in namespace $namespace"
      exit 1
    fi
  fi
done
