###Grafana deployment and configuration

#### Deployment :

##### Pre-requisties: 
- Deploy helm package https://helm.sh/docs/intro/install/
- Deploy kubectl package
 -  https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
- Repo: 
     - https://github.com/AppkubeCloud/kubernetes-monitoring/tree/main/grafana

###### Option-1: Deployment using standalone script:
-  Git clone https://github.com/AppkubeCloud/kubernetes-monitoring.git
-  Go to /<%CLONE_DRT%>/kubernetes-monitoring/grafana>
-  Excecute 
```shell
sh deploy_grafana.sh
```

###### Option-2: Deployment using Tekton pipeline:
 1. Create tekton task if not exists
 <%git_clone%></git_clone%/grafana/tektoncd/tasks>
```shell
 kubectl apply -f grafana-deploy-task.yaml
```

 1. Create tekton pipeline if not exists
 <%git_clone%></git_clone%/grafana/tektoncd/pipeline>
```shell
 kubectl apply -f grafana-deploy-pipeline.yaml
```
 
 2. Create tekton pipelinerun if not exists
 <%git_clone%></git_clone%/grafana/tektoncd/pipelinerun>
 ```shell
kubectl apply -f grafana-deploy-pipelinerun.yaml
```
 
-  Tekton url: http://tekton.synectiks.net/#/about
-  To Rerun pipeline from tekton UI: http://tekton.synectiks.net/#/namespaces/tekton-pipelines/pipelineruns

#### Configuration :
- Grafana url: https://monitoring.synectiks.net/grafana/
- Gateway & Virtualservice :  [Gateway](https://github.com/AppkubeCloud/kubernetes-monitoring/blob/main/prometheus/kubernetes-monitoring-vs.yaml "Gateway")  [Virtualservice](https://github.com/AppkubeCloud/kubernetes-monitoring/blob/main/prometheus/kubernetes-monitoring-vs.yaml "Virtualservice")
#####** Login Credentials**
- Username: admin
- Password:
```shell
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
#####To add prometheus datasource manually
- Goto Grafana > Home > Connections > Datasource >Add new data source
- Select Prometheus > enter url:  http://prometheus-server.prometheus.svc.cluster.local > Test and Save
