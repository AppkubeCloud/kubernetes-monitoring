### Prometheus deployment and configuration

- Deployment 
- Configuration
- Uninstall

#### Deployment :

##### Pre-requisties: 
- Deploy helm package https://helm.sh/docs/intro/install/
- Deploy kubectl package
 -  https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
- Repo: 
     - https://github.com/AppkubeCloud/kubernetes-monitoring/tree/main/prometheus
     - https://prometheus-community.github.io/helm-charts/
     - https://charts.bitnami.com/bitnami

###### Option-1: Deployment using standalone script:
-   Git clone https://github.com/AppkubeCloud/kubernetes-monitoring.git
-   Go to /<%CLONE_DRT%>/kubernetes-monitoring/prometheus-postgres>
-   step1: Deploy postgresql db
```shell
sh deploy_postgresqldb.sh
```
-   step2: Deploy postgres prometheus exporter
```shell
sh deploy_postgresql_exporter.sh
```

###### Option-2: Deployment using Tekton pipeline:
 1. Create tekton task if not exists
 <%git_clone%></git_clone%/prometheus-postgres/tektoncd/tasks>/prometheus-postgres/tektoncd/tasks
```shell
 kubectl apply -f postgresdb-deploy-task.yaml
```
```shell
 kubectl apply -f postgres-exporter-deploy-task.yaml
```
 2. Create tekton pipeline if not exists
 <%git_clone%></git_clone%/prometheus-postgres/tektoncd/tasks>/prometheus-postgres/tektoncd/tasks
```shell
 kubectl apply -f postgres-prometheus-deploy-pipeline.yaml
```
 3. Create tekton pipelinerun if not exists
 <%git_clone%></git_clone%/prometheus-postgres/tektoncd/tasks>/prometheus-postgres/tektoncd/tasks
```shell
 kubectl apply -f postgres-prometheus-deploy-pipelinerun.yaml
```
 
 Tekton url: http://tekton.synectiks.net/#/about
 To Rerun pipeline from tekton UI: http://tekton.synectiks.net/#/namespaces/tekton-pipelines/pipelineruns
#### Configuration :
- Istio enabled for namespace postgresql (istio side car)
- Prometheus url: https://monitoring.synectiks.net/prometheus/
- Auto discovery of services (Update Targets):
- Target details in prometheus service discovery: http://<IP>:9187/metrics
- Service name: prometheus-postgres-exporter
- To connect postgres db: 
```shell
    kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace postgresql --image docker.io/bitnami/postgresql:16.1.0-debian-11-r26 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
      --command -- psql --host postgresql -U postgres -d postgres -p 5432
```
- To connect to your database from outside the cluster execute the following commands:
```shell
    kubectl port-forward --namespace postgresql svc/postgresql 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432
```

#### Uninstall :

- helm uninstall postgresql -n postgresql
- helm uninstall prometheus-postgres-exporter -n postgresql
- (Optional) kubectl delete namespace postgresql
