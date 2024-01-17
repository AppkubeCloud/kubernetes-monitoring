###Grafana deployment and configuration

#### Deployment :

##### Pre-requisties: 
- Deploy helm package https://helm.sh/docs/intro/install/
- Deploy kubectl package
 -  https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
- Repo: 
     - https://github.com/AppkubeCloud/kubernetes-monitoring/tree/main/grafana

###### Option-1: Deployment using script:
-   Git clone https://github.com/AppkubeCloud/kubernetes-monitoring.git
-   Go to /<%CLONE_DRT%>/kubernetes-monitoring/grafana>
-  Run # sh deploy_grafana.sh

###### Option-2: Deployment using Tekton pipeline:
 1. Create tekton task if not exists
 <%git_clone%></git_clone%/grafana/tektoncd/tasks>
 kubectl apply -f grafana-deploy-task.yaml

 1. Create tekton pipeline if not exists
 <%git_clone%></git_clone%/grafana/tektoncd/pipeline>
 kubectl apply -f grafana-deploy-pipeline.yaml
 1. Create tekton pipelinerun if not exists
 <%git_clone%></git_clone%/grafana/tektoncd/pipelinerun>
 kubectl apply -f grafana-deploy-pipelinerun.yaml
 
 Tekton url: http://tekton.synectiks.net/#/about

#### Configuration :
- Grafana url: https://monitoring.synectiks.net/grafana/
- Gateway & Virtualservice :  [Gateway](https://github.com/AppkubeCloud/kubernetes-monitoring/blob/main/prometheus/kubernetes-monitoring-vs.yaml "Gateway")  [Virtualservice](https://github.com/AppkubeCloud/kubernetes-monitoring/blob/main/prometheus/kubernetes-monitoring-vs.yaml "Virtualservice")
##### Login Credentials
Username: admin
Password:
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

