Prometheus Deployment and Configuration
Deployment with Istio
Steps to Deploy Prometheus Services Using Helm
Prerequisites:

Deploy Helm package Helm Installation Guide
Create Namespace:

bash
Copy code
kubectl create namespace prometheus
Enable Istio Injection:

bash
Copy code
kubectl label ns prometheus istio-injection=enabled
Add Prometheus Community Repo:

bash
Copy code
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
Deploy Prometheus Using Helm:

bash
Copy code
helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"
Note:

If there are existing ClusterRole and ClusterRoleBindings related to Prometheus, delete them before deploying Prometheus.
bash
Copy code
kubectl get clusterrolebinding | grep Prometheus
kubectl delete clusterrole prometheusxxxx
Configuration
Update Prometheus Deployment Config for Path-Based URL
Git clone the repository: https://github.com/AppkubeCloud/kubernetes-monitoring.git
From the root directory, run the following command:
bash
Copy code
helm upgrade --reuse-values -f prometheus/values.yaml prometheus prometheus-community/prometheus --namespace prometheus
Create Istio Gateway and Virtual Service
Provide instructions and configuration details for creating Istio Gateway and Virtual Service.

Update scrape_configs for New Targets
Provide details on how to update the scrape_configs configuration for Prometheus with new targets.

Tekton Pipeline to Update scrape_configs for New Targets
Include instructions or details about the Tekton pipeline used to automate the process of updating scrape_configs for new targets.
