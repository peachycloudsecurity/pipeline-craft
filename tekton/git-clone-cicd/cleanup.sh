#!/bin/bash
echo "Cleaning up Tekton resources..."
kubectl delete pipelinerun build-deploy-run --ignore-not-found=true
kubectl delete pipeline build-deploy-pipeline --ignore-not-found=true
kubectl delete task git-clone build-app run-tests trivy-scan deploy-app --ignore-not-found=true
echo "Cleanup completed!"
