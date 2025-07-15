#!/bin/bash

echo "Launching MySQL and Symfony deployments in Kubernetes..."

kubectl apply -f mysql-pv.yaml
kubectl apply -f mysql-pvc.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f symfony-deployment.yaml
kubectl apply -f symfony-service.yaml

