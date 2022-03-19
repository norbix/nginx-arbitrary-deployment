# nginx-arbitrary-deployment
Demonstrates deployment of nginx solution into K8s with helm.


# Ambition 

Create files for deploying the Nginx HTTP server onto a K8S cluster
1. Nginx should be reachable from outside of the K8S cluster
2. Nginx should be reachable by "nginx-sofixit" name inside the K8S cluster
3. Nginx should have persistent storage for static content.
4. Nginx should be configurable without re-building the nginx Docker image
5. Nginx should have its resources limited in order not to hog the underlying machine
6. Nginx should have authentication enabled and configurable without re-building the nginx Docker image
7. (BONUS) Nginx should have SSL encryption enabled and configurable without re-building the nginx Docker image