terraform {
  required_version = "> 0.13.0"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.2.1"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.0, < 2.1.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.34.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0, < 3.0.0"
    }
  }
}

provider "kind" {}


provider "helm" {
  kubernetes {
    config_path = kind_cluster.default.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path = kind_cluster.default.kubeconfig_path
}


provider "kubectl" {
   load_config_file = true
   config_path = kind_cluster.default.kubeconfig_path
}
