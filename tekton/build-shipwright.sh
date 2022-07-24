#!/bin/bash

set -euo pipefail

### https://github.com/shipwright-io/build

kubectl apply --filename https://github.com/shipwright-io/build/releases/download/v0.10.0/release.yaml
kubectl apply --filename https://github.com/shipwright-io/build/releases/download/v0.10.0/sample-strategies.yaml

### https://shipwright.io/docs/getting-started/installation/
### kubectl apply -f https://operatorhub.io/install/shipwright-operator.yaml


cat > build.yaml << EOF
apiVersion: shipwright.io/v1alpha1
kind: Build
metadata:
  name: kaniko-shipwright-build
  annotations:
    build.build.dev/build-run-deletion: "true"
spec:
  source:
    url: https://github.com/hbstarjason2021/pipeline-craft
  strategy:
    name: kaniko
    kind: ClusterBuildStrategy
  output:
    image: hbstarjason/pipeline-craft:shipwright
    credentials:
      name: dockerhub-secret
EOF


cat > buildrun.yaml << EOF
apiVersion: shipwright.io/v1alpha1
kind: BuildRun
metadata:
  name: shipwright-buildrun
spec:
  buildRef:
    name: kaniko-shipwright-build
EOF

kubectl apply -f  build.yaml
kubectl apply -f  buildrun.yaml


tkn taskrun ls |grep shipwright-buildrun |awk '{print $1}'

##### tkn tr logs -f $(tkn taskrun ls |grep shipwright-buildrun |awk '{print $1}')
