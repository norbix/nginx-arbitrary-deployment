# nginx-arbitrary-deployment (NSIK)

## General info 

Demonstrates deployment of nginx solution into K8s with helm.

### Structure 

```sh 
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ tree -L 7 ./
./
├── ~
├── docker:provision-code-ready-container
├── docker:provision-kind
├── LICENSE
├── package
│   └── deployment
│       ├── ci
│       │   ├── README.md
│       │   └── skaffold.yaml
│       └── helm
│           └── nginx-arbitrary-deployment
│               ├── charts
│               ├── Chart.yaml
│               ├── templates
│               │   ├── frontend
│               │   │   ├── configmap.yaml
│               │   │   ├── deployment.yaml
│               │   │   └── service.yaml
│               │   └── _helpers.tpl
│               └── values.yaml
├── README.md
└── Taskfile.yml

10 directories, 18 files
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ 
```

- **package/** contains CI/CD code
- **taskfile.yaml** configuration tool
- **skaffold** local CI/CD engine

## Ambition

Create files for deploying the Nginx HTTP server onto a K8S cluster
1. Nginx should be reachable from outside of the K8S cluster
2. Nginx should be reachable by "nginx-sofixit" name inside the K8S cluster
3. Nginx should have persistent storage for static content.
4. Nginx should be configurable without re-building the nginx Docker image
5. Nginx should have its resources limited in order not to hog the underlying machine
6. Nginx should have authentication enabled and configurable without re-building the nginx Docker image
7. (BONUS) Nginx should have SSL encryption enabled and configurable without re-building the nginx Docker image

## Tasks 

### Provision KIND 

**The usage of 'eval' mechanism allows to transfer state within the same memory stack.** 

```sh 
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ env|grep -i kube
KUBECONFIG=~/.kube/config
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ 
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ eval "$(task docker:provision-kind)"
ERROR: failed to create cluster: node(s) already exist for a cluster with the name "nginx-arbitrary-deployment.cluster"
Deleted clusters: ["nginx-arbitrary-deployment.cluster"]
Creating cluster "nginx-arbitrary-deployment.cluster" ...
 ✓ Ensuring node image (kindest/node:v1.21.1) 🖼
 ✓ Preparing nodes 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
Set kubectl context to "kind-nginx-arbitrary-deployment.cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-nginx-arbitrary-deployment.cluster --kubeconfig /home/norbix/.kube/config.kind

Thanks for using kind! 😊
Execute: command not found
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ env|grep -i kube
KUBECONFIG=/home/norbix/.kube/config.kind
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ k get ns
NAME                 STATUS   AGE
default              Active   72s
kube-node-lease      Active   73s
kube-public          Active   73s
kube-system          Active   73s
local-path-storage   Active   69s
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ 
```

### Provision CRC

* Provisions the following utils:
  * kubectl
  * helm
  * modd
  * kind
  * task

```sh 
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ task docker:provision-code-ready-container
...
root@norbix-crc /mnt/codebase/nginx-arbitrary-deployment (main) $ for each in kubectl helm modd kind task; do which $each;done
/usr/local/bin/kubectl
/usr/local/bin/helm
/usr/local/bin/modd
/usr/local/bin/kind
/usr/local/bin/task
root@norbix-crc /mnt/codebase/nginx-arbitrary-deployment (main) $ 
root@norbix-crc /mnt/codebase/nginx-arbitrary-deployment (main) $ exit
/mnt/codebase/nginx-arbitrary-deployment # 
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ 
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ docker ps|grep -i crc
```

### Run skaffold local CI/CD

```sh 
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ SKAFFOLD_CONFIG=./package/utils/SKAFFOLD_CONFIG/config.yaml skaffold run -f package/deployment/ci/skaffold.yaml 
Generating tags...
Checking cache...
Starting test...
Tags used in deployment:
Starting deploy...
Loading images into kind cluster nodes...
Images loaded in 63ns
Helm release nginx not installed. Installing...
NAME: nginx
LAST DEPLOYED: Sun Mar 20 10:53:47 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
Waiting for deployments to stabilize...
 - deployment/nginx-arbitrary-deployment-frontend: waiting for rollout to finish: 0 of 1 updated replicas are available...
 - deployment/nginx-arbitrary-deployment-frontend is ready.
Deployments stabilized in 8.061 seconds
You can also run [skaffold run --tail] to get the logs
There is a new version (1.35.2) of Skaffold available. Download it from:
  https://github.com/GoogleContainerTools/skaffold/releases/tag/v1.35.2

Help improve Skaffold with our 2-minute anonymous survey: run 'skaffold survey'
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                                   APP VERSION
nginx   default         1               2022-03-20 10:53:47.918824899 +0100 CET deployed        nginx-arbitrary-deployment-0.1.0        1.16.0     
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ k get all
NAME                                                      READY   STATUS    RESTARTS   AGE
pod/nginx-arbitrary-deployment-frontend-6774c45dc-gxf5v   1/1     Running   0          23s

NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes      ClusterIP   10.96.0.1      <none>        443/TCP   38m
service/nginx-sofixit   ClusterIP   10.96.201.22   <none>        80/TCP    23s

NAME                                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-arbitrary-deployment-frontend   1/1     1            1           23s

NAME                                                            DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-arbitrary-deployment-frontend-6774c45dc   1         1         1       23s
norbix@norbix-laptop1-lin20 ~/Desktop/corpo/codebases/priv/nginx-arbitrary-deployment (main) $ 
```