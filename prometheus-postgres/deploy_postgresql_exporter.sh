#!/bin/bash
# Step1: check aws configure
# Step2: configure aws and set default cluster 
# Step3: Deploy Postgres exporter using helm

#Check environment
tekton_dir="/tekton/home/"
if [ -d "$tekton_dir" ]; then
    echo "Env is tekton, export aws credentials"
    export AWS_CONFIG_FILE=/tekton/home/.aws/config
    export AWS_SHARED_CREDENTIALS_FILE=/tekton/home/.aws/credentials
fi
#Export aws access keys
aws_access_key_id=$(aws configure get aws_access_key_id)
aws_secret_access_key=$(aws configure get aws_secret_access_key)
aws_region=$(aws configure get region)
#Check access key values exists
if [ -n "$aws_access_key_id" ] && [ -n "$aws_secret_access_key" ] && [ -n "$aws_region" ]; then
    echo "AWS CLI is properly configured."
    echo "Configure kubectl for eks cluster"
    aws eks update-kubeconfig --region us-east-1 --name myclustTT
    # Create namespace Postgres exporter
    #kubectl create namespace postgresql
    # Enable Istio injection for the postgresql namespace
    #kubectl label ns postgresql istio-injection=enabled --overwrite=true
    exc_dir="-path /proc -o -path /sys -o -path /dev -o -path /run -o -path /var"
    # Find the file, excluding system directories
    file_path=$(find / -type d \( $exc_dir \) -prune -o -type f -name "deploy_postgresql_exporter.sh" -print 2>/dev/null)
    # Check if the file was found
    if [ -n "$file_path" ]; then
        echo "File found at: $file_path"
        # Extract the directory path
        pgex_dir=$(dirname "$file_path")
        echo "File is located in the directory: $pgex_dir"
        # Deploy Postgresql exporter using Helm
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        helm repo update
        helm upgrade -i prometheus-postgres-exporter prometheus-community/prometheus-postgres-exporter -n postgresql  --set-string service.annotations."prometheus\.io/scrape"=true --set-string service.annotations."prometheus\.io/port"=9187   --set config.datasource.host=postgresql.postgresql.svc.cluster.local --set config.datasource.passwordSecret.name=postgresql --set config.datasource.passwordSecret.key=postgres-password  --set config.datasource.password=
        #kubectl apply -f $pgex_dir/../kubernetes-monitoring-vs.yaml
        echo "Postgres exporter deployment successful"
    else
        echo "Postgres exporter deploy script not found."
        exit 1
    fi
else
    echo "AWS CLI is not properly configured. Please run 'aws configure' to set up your AWS credentials."
fi