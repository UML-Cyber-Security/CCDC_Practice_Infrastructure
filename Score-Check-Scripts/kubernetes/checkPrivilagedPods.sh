#!/bin/bash

# Exit code 1 = failed
# Failure would occur on pod having following security issues

# privileged container
# allowed PrivilegeEscalation
# not explicitly set to run as non-root
# non read only filesystem

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
    # Get and print the securityContext.privileged value for each container in the pod
    # Get privileged status
    priv_check=$(kubectl get -n "$namespace" pod "$name" -o json | jq -r '.spec.containers[].securityContext.privileged')

    # Get allowPrivilegeEscalation status
    allow_priv_escalation=$(kubectl get -n "$namespace" pod "$name" -o json | jq -r '.spec.containers[].securityContext.allowPrivilegeEscalation')

    # Get runAsNonRoot status
    run_as_non_root=$(kubectl get -n "$namespace" pod "$name" -o json | jq -r '.spec.containers[].securityContext.runAsNonRoot')

    read_only_root_filesystem=$(kubectl get -n "$namespace" pod "$name" -o json | jq -r '.spec.containers[].securityContext.readOnlyRootFilesystem')

    # Check and print results
    if [ "$priv_check" != "null" ]; then
      #echo "Privileged set to: $priv_check"
      exit 1
    fi

    if [ "$allow_priv_escalation" == "null" ] || [ "$allow_priv_escalation" == "true" ]; then
      #echo "allowPrivilegeEscalation set to: $allow_priv_escalation"
      exit 1
    fi

    if [ "$run_as_non_root" == "null" ] || [ "$run_as_non_root" == "true" ]; then
      true
    else
      # echo "runAsNonRoot set to: $run_as_non_root"
      exit 1
    fi

    if [ "$read_only_root_filesystem" == "null" ] || [ "$read_only_root_filesystem" == "true" ]; then
      true
    else
      # echo "readOnlyRootFilesystem set to: $read_only_root_filesystem"
      exit 1
    fi

  fi
done
