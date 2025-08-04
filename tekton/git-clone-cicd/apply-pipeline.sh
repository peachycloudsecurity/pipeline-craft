#!/bin/bash
echo "Applying Tekton Tasks..."
kubectl apply -f task-git-clone.yaml
kubectl apply -f task-build.yaml
kubectl apply -f task-test.yaml
kubectl apply -f task-trivy-scan.yaml
kubectl apply -f task-deploy.yaml

echo "Applying Pipeline..."
kubectl apply -f pipeline.yaml

echo "Running Pipeline..."
kubectl apply -f pipelinerun.yaml

echo "Checking Status..."
tkn pipelinerun list
