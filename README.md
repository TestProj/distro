# InfraProj
This Project will help on Executing the Chaos and Performance execution leverging open source tools

#### Assumption
- You have AWS account access 
- You have kubernetes cluster running on using AWS resources

#### Prereq 
- Kubernetes Cluster installed and setup on your infrastrutre 
- You have access to connect to this cluster and execute kubectl in admin mode
#### Argo Workflows
The [Argo](https://github.com/argoproj/argo) workflow infra consists of the Argo workflow CRDs, Workflow Controller, associated RBAC & Argo CLI. The steps
shown below installs argo in the standard cluster-wide mode wherein the workflow controller operates on all
namespaces. Ensure that you have the right permission to be able to create the said resources.

If you would like to run argo with a namespace scope, refer to [this](https://github.com/argoproj/argo/blob/master/manifests/namespace-install.yaml) manifest.

- Create argo namespace
  ```
  ➜  InfraProj git:(master) ✗ kubectl create ns argo
  ```
- Create the CRDs, workflow controller deployment with associated RBAC
  ```
  ➜  InfraProj git:(master) ✗ kubectl apply -f https://raw.githubusercontent.com/argoproj/argo/stable/manifests/install.yaml
  ```
- Verify successful creation of argo resources (crds)
```
InfraProj git:(master) ✗ kubectl get crds | grep argo
clusterworkflowtemplates.argoproj.io          2020-05-14T04:57:16Z
cronworkflows.argoproj.io                     2020-05-14T04:57:18Z
workflows.argoproj.io                         2020-05-14T04:57:20Z
workflowtemplates.argoproj.io                 2020-05-14T04:57:21Z
```
- Verify successful creation of argo resources (api-resources)
```
InfraProj git:(master) ✗ kubectl api-resources | grep argo
clusterworkflowtemplates          clusterwftmpl,cwft   argoproj.io                    false        ClusterWorkflowTemplate
cronworkflows                     cwf,cronwf           argoproj.io                    true         CronWorkflow
workflows                         wf                   argoproj.io                    true         Workflow
workflowtemplates                 wftmpl               argoproj.io                    true         WorkflowTemplate
```
- Verify successful creation of argo server and workflow
```
InfraProj git:(master) ✗  kubectl get pods -n argo
NAME                                   READY   STATUS    RESTARTS   AGE
argo-server-78b774dd56-j8xwx           1/1     Running   0          13h
workflow-controller-589bf468d7-bwjtr   1/1     Running   0          13h
```

- How to access the argo UI
Please follow the instruction [here](https://github.com/argoproj/argo/blob/master/docs/quick-start.md)
```
kubectl -n argo port-forward deployment/argo-server 2746:2746
```
This will serve the user interface on http://localhost:2746

- Install the argo CLI on the harness/test machine (where the kubeconfig is available)
```
InfraProj git:(master) curl -sLO https://github.com/argoproj/argo/releases/download/v2.8.0/argo-linux-amd64
InfraProj git:(master) chmod +x argo-linux-amd64
InfraProj git:(master) mv ./argo-linux-amd64 /usr/local/bin/argo
InfraProj git:(master) argo version
  argo: v2.8.0
  BuildDate: 2020-05-11T22:55:16Z
  GitCommit: 8f696174746ed01b9bf1941ad03da62d312df641
  GitTreeState: clean
  GitTag: v2.8.0
  GoVersion: go1.13.4
  Compiler: gc
  Platform: linux/amd64
``` 
#### Setup Application 
- Create a namespace for chaos experiment as app-ns
```
  ➜  InfraProj git:(master) ✗ kubectl create ns app-ns
```
- Install a simple multi-replica stateless nginx deployment with service exposed over nodeport
```
➜  InfraProj git:(master) ✗ kubectl  apply -f nginx_demo.yaml
deployment.apps/nginx-demo-app created
service/nginx-demo-app-svc created
  ```
  ```
InfraProj git:(master) ✗ kubectl get pods -l app=nginx-demo-app  -w
NAME                              READY   STATUS    RESTARTS   AGE
nginx-demo-app-68c58bb7d7-fg2bc   1/1     Running   0          94s
nginx-demo-app-68c58bb7d7-jfrrr   1/1     Running   0          94s
nginx-demo-app-68c58bb7d7-s98wz   1/1     Running   0          94s
  ```
- You can access this service over `https://<node-ip>:<nodeport>`
- If you use ingress you might get ingress endpoint for application

### Support for other cloud Provider 
- WIP

### Support for Minikube
- WIP

