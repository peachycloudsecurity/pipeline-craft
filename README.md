# 基于SpringBoot的E2E DevOps Pipeline Demo

最终访问地址：https://pipeline-craft.herokuapp.com/

 应用描述：

| 语言     | SpringBoot      |      |
| -------- | --------------- | ---- |
| 运行环境 | JDK 1.8         |      |
| 构建工具 | Maven           |      |
| 部署环境 | AWS EKS、Heroku |      |

说明：核心重点主要是CICD，本demo包含3条Pipeline，适用于不同的场景。



## 1、基于Github Actions

**主要过程描述：**

- CI部分：利用Github Actions自动完成步骤：Checkout repo、Maven Testing、Mvn  package、Upload Artifact、Build and push Docker image to Dockerhub、Deploy to Heroku。
- CD部分：利用Github Actions自动内部启动一个MiniKube集群，并自动完成部署验证测试。

**亮点：**完全只利用Github原生实现整个CI和CD过程，不依赖任何第3方。

**适用场景：**基于Github的个人以及小型团队组织、初创公司等的开源项目。



## 2、基于Travis-CI（travis-ci.org）

**主要过程描述：**与上述Github Actions的步骤一致，另外增加了集成sonarcloud.io，自动对代码进行扫描。

**亮点：**方便快捷集成第3方各种平台。

**适用场景：**解耦Github，可随意使用任何第3方。



## 3、基于Jenkins+Kubernetes

~~Terraform+AWS EKS+Gitlab（Github）+Jenkins（Kaniko、tekton）+Jfrog Artifactory+Harbor+ArgoCD（Helm）+ArgoRollouts（Spinnaker）+Prometheus+Elastic Stack（Skywalking）~~

由于资源有限，采取以下更轻量更高效方案：

- AWS EKS+Github+Kaniko+ArgoCD+ArgoRollouts
- JFrog Artifactory+Elastic Stack

主要过程描述：

亮点：~~Dynamic-Slave~~、Kaniko、Skaffold、GitOps、Multi-Cluster、Auto Canary

- 通过Kaniko来完全替换Jenkins构建镜像。（如想了解jenkins构建镜像，请猛击：https://github.com/hbstarjason/springboot-devops-demo）
- 以Sidecar模式来部署，真正实现应用与环境解耦。

适用场景：内网私有云、开源组件灵活可替换，完全解耦。各个工具各司其职，专业工具干专业活。



相关连接：

- argocd：
  http://a4bb9d7ef5bb344d7bfa93580ac32862-1007326277.cn-northwest-1.elb.amazonaws.com.cn:8081
- kuboard：
  http://a95ae2482b8474fdcbecbe49e7ccb3cc-1915316544.cn-northwest-1.elb.amazonaws.com.cn:81
- jenkins:
  http://ac3d2f43b8d1d45c58c143e6b4fcc49f-1916756479.cn-northwest-1.elb.amazonaws.com.cn:8088/
- skywalking：
  http://ada285066410d4037a3c0e30e775eb90-680859113.cn-northwest-1.elb.amazonaws.com.cn:8088/





# History

- 2020-09-26，增加以Sidecar的模式进行部署。
- 2020-09-17，增加Kaniko和Skaffold。
- 2020-08-20，完成基于Travis-CI的pipeline，集成sonarcloud.io，自动进行代码扫描。
- 2020-08-19，完成基于原生Github Actions的Pipeline，不依赖任何第3方。



```bash
$ sudo apt-get update && sudo apt-get install openjdk-8-jdk -y

$ mvn -B clean package -DskipTests

# kaniko build image
$ export DOCKERSERVER="https://index.docker.io/v1/"
$ export DOCKERREPO="hbstarjason"
$ export DOCKERPASS="<YOUR_DOCKER_PASS>"
$ export DOCKEREMAIL="<YOUR_DOCKER_EMAIL>"

$ kubectl create secret docker-registry hbstarjason \
    --docker-server=${DOCKERSERVER} \
    --docker-username=${DOCKERREPO} \
    --docker-password=${DOCKERPASS} \
    --docker-email=${DOCKEREMAIL}

$ kubectl apply -f kaniko/build.yaml

# Skaffold
$ curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
  chmod +x skaffold && \
  sudo mv skaffold /usr/local/bin && \
  skaffold version
$ skaffold dev
```

