#!/bin/bash
#==================================================================================================
#   Objective of this script is to get append new target in scrape_configs to collect metrics for 
#   appkube services.
#==================================================================================================
if [ "$#" -lt 3 ]; then
  echo 'Required 3 parameters, usage:- ./append_target.sh job_name metrics_path new_target_ip'
  echo 'Example:- ./append_target.sh appkube_cmdb /cmdb/management/prometheus api.synectiks.net'
  echo 'Make sure network access to discover new target'
  exit 1
fi
NEW_JOB_NAME=$1
NEW_METRICS_PATH=$2
NEW_TARGET=$3
CONFIGMAP_NAME="prometheus-server"

# Retrieve the existing ConfigMap YAML to a file
kubectl get configmap $CONFIGMAP_NAME -n prometheus -o yaml > prometheus-configmap.yaml

# Generate the new scrape_config entry
NEW_SCRAPE_CONFIG=$(cat <<EOL
    - job_name: '$NEW_JOB_NAME'
      metrics_path: '$NEW_METRICS_PATH'
      static_configs:
      - targets: ['$NEW_TARGET']
EOL
)

# Add the new scrape_config entry to the existing ConfigMap YAML
printf "/scrape_configs:/a\n%s\n.\nw\nq" "$NEW_SCRAPE_CONFIG" | ed -s prometheus-configmap.yaml

# Apply the modified ConfigMap to the cluster
#kubectl apply -f prometheus-configmap.yaml

echo "ConfigMap updated and reapplied successfully."
