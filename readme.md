### KinD: Kubernetes cluster in Docker

> https://kubernetes.io/blog/2020/05/21/wsl-docker-kubernetes-on-the-windows-desktop/ <br>
> https://spring.io/guides/gs/spring-boot-kubernetes/

1. Install KinD

```shell script
# Download the latest version of KinD
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.8.1/kind-linux-amd64
# Make the binary executable
chmod +x ./kind
# Move the binary to your executable path
sudo mv ./kind /usr/local/bin/
```

2. Create 3-node k8s-cluster

```
kind create cluster --name wslkindmultinodes --config k8s/kind-3nodes.yaml
```

3. Build the demo app

```
mvn package -Dmaven.test.skip=true
```

4. Build and push your docker image

```
docker build -t <you docker-hub profile>/k8s-demo .
docker push <you docker-hub profile>/k8s-demo
```

5. Deploy your app to k8s cluster

    - Create deployment.yml
    ```
    kubectl create deployment k8s-demo --image=<you docker-hub profile>/k8s-demo --dry-run -o=yaml > k8s/deployment.yaml &&
    echo --- >> k8s/deployment.yaml &&
    kubectl create service clusterip k8s-demo --tcp=8080:8080 --dry-run -o=yaml >> k8s/deployment.yaml    
    ```
    
    - Deploy
    ```
    kubectl apply -f k8s/deployment.yaml
    ```
    
    - Test deployment (wait for status = Running of pod/k8s-demo-*)   
    
    ```
    kubectl get all
    ```   
    
    - Port forward to your application
    ```
    kubectl port-forward svc/k8s-demo 8080:8080 
    ```
    
    - Test your app (in another terminal)
    ```
    curl localhost:8080/actuator/health
    ```

6. Remove the k8s-cluster
```
kind delete cluster --name $(kind get clusters)
```    