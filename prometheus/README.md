Prometheus deployment and configuration
•	Deployment with istio
•	Configuration
•	Create istio gateway and virtual service 
•	Update scrape_configs for new targets
•	Tekton pipeline to update scrape_configs for new targets
Deployment with istio:
 Steps to deploy prometheus services using helm
Pre-requisties: Deploy helm package https://helm.sh/docs/intro/install/ 
1.	Create namespace 
kubectl create namespace prometheus
2.	Enable istio-injection
kubectl label ns prometheus istio-injection=enabled
3.	Add Prometheus community repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
4.	Deploy Prometheus using helm
helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"
Note: 
If any existing clusterrole and cluster rolebindings related to Prometheus, delete before deploying Prometheus.
kubectl get clusterrolebinding | grep Prometheus
kubectl delete clusterrole prometheusxxxx

Configuration:
Update Prometheus deployment config for path based url
•	Git clone repo https://github.com/AppkubeCloud/kubernetes-monitoring.git from root directory run below command
helm upgrade --reuse-values -f prometheus/values.yaml prometheus prometheus-community/prometheus --namespace prometheus
Create istio gateway and virtual service:

Update scrape_configs

