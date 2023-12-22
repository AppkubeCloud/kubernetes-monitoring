**Prometheus deployment and configuration**

- **Deployment with istio**
- **Configuration**
- **Create istio gateway and virtual service**
- **Update scrape\_configs for new targets**
- **Tekton pipeline to update scrape\_configs for new targets**

**Deployment with istio:**

Steps to deploy prometheus services using helm

Pre-requisties: Deploy helm package [https://helm.sh/docs/intro/install/](https://helm.sh/docs/intro/install/)

1. Create namespace

_kubectl create namespace prometheus_

1. Enable istio-injection

_kubectl label ns prometheus istio-injection=enabled_

1. Add Prometheus community repo

_helm repo add prometheus-community_ [_https://prometheus-community.github.io/helm-charts_](https://prometheus-community.github.io/helm-charts)

1. Deploy Prometheus using helm

_helm upgrade -i prometheus prometheus-community/prometheus \_

_--namespace prometheus \_

_--set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"_

**Note:**
 If any existing clusterrole and cluster rolebindings related to Prometheus, delete before deploying Prometheus.
_kubectl get clusterrolebinding | grep Prometheus_

_kubectl delete clusterrole prometheusxxxx_

**Configuration:**

Update Prometheus deployment config for path based url

- Git clone repo [https://github.com/AppkubeCloud/kubernetes-monitoring.git](https://github.com/AppkubeCloud/kubernetes-monitoring.git) from root directory run below command

helm upgrade --reuse-values -f prometheus/values.yaml prometheus prometheus-community/prometheus --namespace prometheus

**Create istio gateway and virtual service:**

**Update scrape\_configs**
