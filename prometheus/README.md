###Prometheus deployment and configuration

- Deployment 
- Configuration

#### Deployment :

##### Pre-requisties: 
- Deploy helm package https://helm.sh/docs/intro/install/
- Deploy kubectl package
 -  https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
- Repo: 
     - https://github.com/AppkubeCloud/kubernetes-monitoring/tree/grafana/prometheus

###### Option-1: Deployment using standalone script:
-   Git clone https://github.com/AppkubeCloud/kubernetes-monitoring.git
-   Go to /<%CLONE_DRT%>/kubernetes-monitoring/prometheus>
-  execute
```shell
sh deploy_prometheus.sh
```

###### Option-2: Deployment using Tekton pipeline:
 1. Create tekton task if not exists
 <%git_clone%></git_clone%/prometheus/tektoncd/tasks>/prometheus/tektoncd/tasks
```shell
 kubectl apply -f prometheus-deploy-task.yaml
```

 2. Create tekton pipeline if not exists
 <%git_clone%></git_clone%/prometheus/tektoncd/tasks>/prometheus/tektoncd/tasks
```shell
 kubectl apply -f prometheus-deploy-pipeline.yaml
```
 3. Create tekton pipelinerun if not exists
 <%git_clone%></git_clone%/prometheus/tektoncd/tasks>/prometheus/tektoncd/tasks
```shell
 kubectl apply -f prometheus-deploy-pipelinerun.yaml
```
 
 Tekton url: http://tekton.synectiks.net/#/about
 To Rerun pipeline from tekton UI: http://tekton.synectiks.net/#/namespaces/tekton-pipelines/pipelineruns
#### Configuration :
- Prometheus url: https://monitoring.synectiks.net/prometheus/
- Gateway & Virtualservice :  [Gateway](https://github.com/AppkubeCloud/kubernetes-monitoring/blob/main/prometheus/kubernetes-monitoring-vs.yaml "Gateway")  [Virtualservice](https://github.com/AppkubeCloud/kubernetes-monitoring/blob/main/prometheus/kubernetes-monitoring-vs.yaml "Virtualservice")
- Auto discovery of services (Update Targets):
###### Method-1:
<%git_clone%>/prometheus/
execute 
```shell
./append_target.sh param1 param2 param3
```
param1: job_name,param2: metrics_path, param3: new_target_ip
Wait for few mins to config reload automatically.
###### Method-2:
Auto discovery of services based on scrape config annotations 
ex: [service.yaml](https://github.com/AppkubeCloud/appkube-cmdb-deployment/blob/main/helm/templates/service.yaml "service.yaml")

 Below annotations should be included as part of appkube service deployment

     annotations:
             prometheus.io/scrape: 'true'
             prometheus.io/job: appkube-cmdb_test
             prometheus.io/path: /management/prometheus
             prometheus.io/port: '6057'
             prometheus.io/label: environment=devtest,app=appkube_cmdb_test
    
