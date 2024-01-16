#!/bin/bash

# deploy-prometheus.sh

# Configure aws 
echo "configure aws"
export AWS_CONFIG_FILE=/tekton/home/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/tekton/home/.aws/credentials

#Configure kubectl
echo "Configure kubectl for eks cluster"
aws eks update-kubeconfig --region us-east-1 --name myclustTT
#aws configure list
echo "List repo, ls -al /workspace/source/"
#ls -al /workspace/source/
echo "Check kubectl version"
kubectl version --short --client

# Create namespace prometheus
kubectl create namespace prometheus

# Enable Istio injection for the prometheus namespace
kubectl label ns prometheus istio-injection=enabled --overwrite=true

# Change directory to the workspace
prom_dir=/workspace/source/prometheus
cd $prom_dir

# Deploy Prometheus using Helm 
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade -i prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2" -f $prom_dir/values.yaml

#Update Prometheus configuration
#helm upgrade --reuse-values -f $prom_dir/values.yaml prometheus prometheus-community/prometheus --namespace prometheus

#Update Prometheus istio-gateway
kubectl apply -f /workspace/source/kubernetes-monitoring-vs.yaml
echo "Prometheus deployment successful"
