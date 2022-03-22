# Local CI/CD via skaffold DSL 

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

# Local CI/CD via cmd REPL

```sh 
cd package/deployment/helm/nginx-arbitrary-deployment/
# Eval
helm upgrade --install --debug --dry-run nginx-arbitrary-deployment .

# Deploy
helm upgrade --install nginx-arbitrary-deployment .

# REPL debug
k get ns
k get all,ing
helm upgrade --install nginx-arbitrary-deployment .
k get all,ing 
helm list 
k exec -it pod/nginx-arbitrary-deployment-5d894d7767-7tvgr bash
apt-get update -y; apt-get install procps curl vim apache2-utils -y
alias ll='ls -la'
ps -ef
ll /etc/nginx/
k edit configmap/
nginx -T
ps -ef|grep -i nginx
kill -<pid> #
nginx -T

#
# Port tunneling
# 
k port-forward pod/nginx-arbitrary-deployment-frontend-8864f4c8d-cnnm4 8080:80 &
curl localhost:8080
kill -9 %1

#
# Uninstall
#
helm uninstall nginx-arbitrary-deployment

#
# Manual test
# 
k run --image=nginx:1.16.0 norbix-repl
k exec -it norbix-repl bash
curl nginx-sofixit
```