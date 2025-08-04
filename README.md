# Tekton CI/CD Pipeline Demo

This repository demonstrates an **end-to-end CI/CD pipeline** using **Tekton Pipelines** for building and pushing a Spring Boot application container image using **Kaniko**, without relying on Docker-in-Docker or Jenkins.

> 💡 This is a fork of the original project [`pipeline-craft`](https://github.com/hbstarjason2021/pipeline-craft), licensed under [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0). This fork retains only the **Tekton-specific pipeline workflow**, adapted and updated by **Peachy Cloud Security**.

---

## 🚀 Lab Scenario Overview

| Component                 | Purpose                                               |
| ------------------------- | ----------------------------------------------------- |
| **Language**              | Java (Spring Boot)                                    |
| **Build Tool**            | Maven                                                 |
| **CI/CD Engine**          | Tekton Pipelines                                      |
| **Image Build**           | Kaniko (rootless, daemonless image builder)           |
| **Container Registry**    | DockerHub (authenticated push)                        |
| **Monitoring (Optional)** | kube-prometheus-stack (Prometheus + Grafana via Helm) |

---

## ✅ Pipeline Flow (Simplified)

1. **Echo Hello World**
   – Test TaskRun to validate Tekton setup.

2. **Git Clone TaskRun**
   – Clones the source code into a shared PVC using `git-clone` Task.

3. **Build and Push TaskRun (Kaniko)**
   – Builds the Docker image using Kaniko and pushes it to DockerHub.

4. **Trivy Scan TaskRun (Optional)**
   – Scans the pushed image for vulnerabilities using Trivy.

5. **Full PipelineRun**
   – Combines all steps into an automated end-to-end pipeline.

---

## 🛠️ Usage Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/peachycloudsecurity/pipeline-craft.git
   cd pipeline-craft/tekton
   ```

2. Create DockerHub secret for Kaniko authentication:

   ```bash
   kubectl create secret docker-registry dockerhub-secret \
     --docker-server=https://index.docker.io/v1/ \
     --docker-username=<your-docker-username> \
     --docker-password=<your-docker-password> \
     --docker-email=<your-email>
   ```

3. Apply required PVC and Task YAMLs (refer to `task-build-and-push.yaml`, `task-trivy-scan.yaml`).

4. Apply Pipeline and PipelineRun for full execution:

   ```bash
   kubectl apply -f official_demo.yaml
   kubectl apply -f official_demo-run.yaml
   ```

5. View logs:

   ```bash
   tkn pipelinerun logs hello-goodbye-run -f
   ```

---

## 📜 License & Credits

This project is based on the original **[pipeline-craft](https://github.com/hbstarjason2021/pipeline-craft)** by [hbstarjason2021](https://github.com/hbstarjason2021), licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

This fork by **Peachy Cloud Security** focuses exclusively on Tekton-based CI/CD workflows.

---

## 🤝 Contribution

Feel free to fork and enhance the Tekton-based CI/CD pipeline.
For the complete DevOps workflows including GitHub Actions, Travis CI, and Jenkins, refer to the [original repository](https://github.com/hbstarjason2021/pipeline-craft).
