#
# Manual stratgy
#

```sh 
cd package/deployment/helm/nginx-arbitrary-deployment/
helm upgrade --install --debug --dry-run nginx-arbitrary-deployment .
k get ns
k get all,ing
helm upgrade --install nginx-arbitrary-deployment .
k get all,ing 
helm list 
k exec -it pod/nginx-arbitrary-deployment-5d894d7767-7tvgr bash
apt-get update -y; apt-get install procps curl vim -y
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