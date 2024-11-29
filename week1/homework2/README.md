# Week1: Homework2

## set  aws credentials as TF vars
```shell
export TF_VAR_AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} TF_VAR_AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} TF_VAR_AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}
```
## Apply Terraform
```shell
cd terraform && terraform apply
```
## Set kind cluster kubeconfig
export KUBECONFIG=<path>/geekbang-aiops-homeworks/week1/homework2/terraform/test-cluster_k8s_config 

## apply elasticache via crossplane
```shell
kubectl apply -f elasticache/elasticache.yaml
```