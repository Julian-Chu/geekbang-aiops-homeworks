resource "kind_cluster" "default" {
  name = var.cluster_name
  kubeconfig_path = local.k8s_config_path
}