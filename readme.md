### KinD: Kubernetes cluster in Docker

> https://kubernetes.io/blog/2020/05/21/wsl-docker-kubernetes-on-the-windows-desktop/ <br>
> https://spring.io/guides/gs/spring-boot-kubernetes/ <br>
> https://spring.io/guides/gs/spring-boot-docker/ <br>
> https://spring.io/guides/topicals/spring-boot-docker/ <br>
> https://spring.io/blog/2020/06/18/what-s-new-in-spring-boot-2-3

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

```shell script
kind create cluster --name wslkindmultinodes --config k8s/kind-3nodes.yaml
```

3. Build the demo app

```shell script
mvn package -Dmaven.test.skip=true
```

4. Build and push your docker image
    
    - Build the image with Dockerfile

    ```shell script
    docker build -t <you docker-hub profile>/k8s-demo:dockerfile .    
    ```

    - Or build the image [directly using buildpack](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-container-images-buildpacks)
    
    ```shell script
    mvn spring-boot:build-image -Dspring-boot.build-image.imageName=<you docker-hub profile>/k8s-demo:buildpack
    ```

    - Push the image
    
    ```shell script
    docker push <you docker-hub profile>/k8s-demo:<dockerfile or buildpack>
    ```

5. Deploy your app to k8s cluster

    - Create deployment.yml
    ```shell script
    kubectl create deployment k8s-demo --image=<you docker-hub profile>/k8s-demo:<dockerfile or buildpack> --dry-run -o=yaml > k8s/deployment.yaml &&
    echo --- >> k8s/deployment.yaml &&
    kubectl create service clusterip k8s-demo --tcp=8080:8080 --dry-run -o=yaml >> k8s/deployment.yaml    
    ```
    
    - Deploy
    ```shell script
    kubectl apply -f k8s/deployment.yaml
    ```
    
    - Test deployment (wait for status = Running of pod/k8s-demo-*)   
    
    ```shell script
    kubectl get all
    ```   
    
    - Port forward to your application
    ```shell script
    kubectl port-forward svc/k8s-demo 8080:8080 
    ```
    
    - Test your app (in another terminal)
    ```shell script
    curl localhost:8080/actuator/health
    ```

6. Remove the k8s-cluster
```shell script
kind delete cluster --name $(kind get clusters)
```    