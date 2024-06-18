#!/bin/bash

# This is checking the security context. It needs some work as I need to TODO: check if privileged is required
# for certain security policies in namespaces
# There are three levels for namespace wide security policies
# [here](https://kubernetes.io/docs/concepts/security/pod-security-admission/)
# [here](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
# Ideally we want it on restricted if it can still function.

namespaces=$(kubectl get namespaces --no-headers -o custom-columns=":metadata.name")

# Split the string into an array of lines
readarray -t namespaces_array <<<"$namespaces"

for namespace in "${namespaces_array[@]}"; do
  run_as_non_root=$(kubectl get namespace "$namespace" -o json | jq -r '.metadata.labels["pod-security.kubernetes.io/enforce"]')
  if [ "$run_as_non_root" != "null" ] || [ "$run_as_non_root" == "privileged" ]; then
    #echo "$namespace is privileged"
    exit 1
  fi
done
