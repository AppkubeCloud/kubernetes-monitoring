#!/bin/bash

# deploy-prometheus.sh
echo "From Task script"
export AWS_CONFIG_FILE=/tekton/home/.aws/config
export AWS_SHARED_CREDENTIALS_FILE=/tekton/home/.aws/credentials
echo "Configure kubectl for eks cluster"
aws eks update-kubeconfig --region us-east-1 --name myclustTT
aws configure list
echo "List repo, ls -al /workspace/source"
ls -al /workspace/source/
ls -al /workspace/source/prometheus/
echo "Check kubectl presence"
kubectl version --short --client
