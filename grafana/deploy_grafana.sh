#!/bin/bash

# deploy-prometheus.sh

# Configure aws 
echo "configure aws"
export AWS_CONFIG_FILE=/tekton/home/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/tekton/home/.aws/credentials

#Configure kubectl
echo "Configure kubectl for eks cluster"
aws eks update-kubeconfig --region us-east-1 --name myclustTT
##aws configure list
echo "List repo, ls -al /workspace/source/"
#ls -al /workspace/source/"
#echo "Check kubectl version"
##kubectl version --short --client

# Create namespace prometheus
kubectl create namespace grafana

# Enable Istio injection for the prometheus namespace
kubectl label ns grafana istio-injection=enabled --overwrite=true

# Change directory to the workspace
prom_dir=/workspace/source/grafana
cd $graf_dir

# Deploy grafana using Helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade -i  grafana grafana/grafana -n grafana -f $graf_dir/values.yaml

#kubectl apply -f /workspace/source/kubernetes-monitoring-vs.yaml
echo "grafana deployment successful"
