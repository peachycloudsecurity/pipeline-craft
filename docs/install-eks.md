

```sh
# 登录Dashboard手动创建
# 使用eksctl创建
# 使用Terraform创建

# 安装Kubectl
# https://docs.amazonaws.cn/eks/latest/userguide/install-kubectl.html
$ curl -o kubectl https://amazon-eks.s3.cn-north-1.amazonaws.com.cn/1.17.9/2020-08-04/bin/linux/amd64/kubectl && \
 chmod +x ./kubectl && \
 sudo mv ./kubectl /usr/local/bin

# 安装Aws Cli
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  apt install unzip -y && unzip awscliv2.zip && \
  sudo ./aws/install && \
  aws --version

# 创建访问凭据
# 右上角，我的安全凭证-->创建访问秘钥

# 创建kubeconfig
# https://docs.amazonaws.cn/eks/latest/userguide/create-kubeconfig.html

$ aws configure
AWS Access Key ID [None]: XXXXXX
AWS Secret Access Key [None]: XXXXXX
Default region name [None]: cn-northwest-1
Default output format [None]:

$ aws eks --region cn-northwest-1 update-kubeconfig --name <集群名称>

$ kubectl get node 
```

