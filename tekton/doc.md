# Tekton Pipeline Flows (Separated Scenarios)

## Tekton Installation Steps

### 1. Install Tekton Pipelines

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl api-resources --api-group=tekton.dev
kubectl get po -n tekton-pipelines
```

### 2. Install Tekton CLI

```bash
curl -sLO https://github.com/tektoncd/cli/releases/download/v0.31.0/tkn_0.31.0_Linux_x86_64.tar.gz

# Extract in current directory
tar xvzf tkn_0.31.0_Linux_x86_64.tar.gz

# Move binary to /usr/local/bin
sudo mv tkn /usr/local/bin/

# Verify installation
tkn version
```

### 3. Install GitClone Task

```bash
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml
tkn hub install task git-clone
```

### 4. Install Tekton Dashboard

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml
kubectl get pods --namespace tekton-pipelines
kubectl get svc tekton-dashboard -n tekton-pipelines
kubectl port-forward -n tekton-pipelines --address=0.0.0.0 service/tekton-dashboard 8080:9097 > /dev/null 2>&1 &
```

---

- Install Tekton Chains

```bash
kubectl apply -f https://storage.googleapis.com/tekton-releases/chains/latest/release.yaml

curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

wget https://github.com/hidetatz/kubecolor/releases/download/v0.0.20/kubecolor_0.0.20_Linux_x86_64.tar.gz && tar zvxf kubecolor_0.0.20_Linux_x86_64.tar.gz && sudo cp kubecolor /usr/local/bin/ && kubecolor version 
```
- Clone the github repo.

```bash
git clone https://github.com/peachycloudsecurity/pipeline-craft && cd pipeline-craft/tekton && ls -l 

```

## Flow 1: Simple Hello-Goodbye Pipeline (Demo Scenario)

- Initial Setup
```bash
# PipelineResource is deprecated. Skip 01-pipelineresource.yaml
kubectl apply -f 02-git-secret.yaml
kubectl apply -f 03-dockerhub-secret.yaml
kubectl apply -f 04-build-sa.yaml
```

- Flow 1: First TaskRun Test (Hello World Demo)

```bash
kubectl apply -f task-echo-hello-world.yaml
kubectl apply -f taskrun-echo-hello-world.yaml

kubectl get po
tkn taskrun list
tkn taskrun logs taskrun-echo-hello-world
```

- Prerequisite: Correct DockerHub Secret (dockerconfigjson type)

```bash
kubectl get secret dockerhub-secret -o yaml || echo "Secret does not exist"

# Delete old secret if type is kubernetes.io/basic-auth
kubectl delete secret dockerhub-secret --ignore-not-found

# Create correct dockerconfigjson type secret
kubectl create secret docker-registry dockerhub-secret \
  --docker-username= \
  --docker-password='@123#' \
  --docker-email=your-email@example.com

kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "dockerhub-secret"}]}'
```

- Apply the git-clone Task from Tekton Catalog

```bash
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml
```
```bash
# Apply the updated files
kubectl delete -f tasks/task-build.yaml
kubectl delete -f pipeline.yaml
kubectl delete -f pipelinerun.yaml

# Check status
tkn pipelinerun list
tkn pipelinerun logs build-deploy-run
```


- Wait till GitClone TaskRun Succeeds:

```bash
tkn taskrun list  # Ensure git-clone-taskrun is Succeeded
```

- Run Build-and-Push TaskRun (this will now find Dockerfile in workspace)
```bash
kubectl apply -f taskrun-build-and-push.yaml
```

- Run Trivy Scan after image is built successfully

```bash
kubectl apply -f taskrun-trivy-image.yaml
```
## Prometheus & Grafana Setup (Monitoring Stack)

### 1. Install Standalone Prometheus

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus -n default \
  --set alertmanager.enabled=false,pushgateway.enabled=false,server.global.scrape_interval=10s, \
  alertmanager.persistentVolume.enabled=false,server.persistentVolume.enabled=false,pushgateway.persistentVolume.enabled=false

kubectl port-forward --address 0.0.0.0 svc/prometheus-server 9999:80 > /dev/null 2>&1 &

# Access Prometheus at: http://localhost:9999
```

### 2. Install kube-prometheus-stack (Prometheus + Grafana)

```bash
helm repo list && helm repo update
kubectl create ns monitor
helm install prometheus-stack prometheus-community/kube-prometheus-stack -n monitor

# Port-forward Prometheus
kubectl port-forward -n monitor --address=0.0.0.0 svc/prometheus-stack-kube-prom-prometheus 9090:9090 > /dev/null 2>&1 &

# Port-forward Grafana
kubectl port-forward -n monitor --address=0.0.0.0 svc/prometheus-stack-grafana 80:80 > /dev/null 2>&1 &

# Grafana Credentials: admin/prom-operator

# Access:
# Prometheus → http://localhost:9090
# Grafana → http://localhost
```
