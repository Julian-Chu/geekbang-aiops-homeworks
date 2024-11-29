resource "helm_release" "crossplane" {
  name       = "crossplane"

  repository       = "https://charts.crossplane.io/stable"
  chart            = "crossplane"
  namespace        = kubernetes_namespace_v1.crossplane_system.metadata[0].name
  create_namespace = true
}

resource "kubernetes_namespace_v1" "crossplane_system" {
  metadata {
    name = "crossplane-system"
  }
}

resource "kubectl_manifest" "crossplane_aws_elasticache_provider" {
  server_side_apply = true
  force_conflicts   = true
  wait = true
  yaml_body         = <<YAML
    apiVersion: pkg.crossplane.io/v1
    kind: Provider
    metadata:
      name: provider-aws-elastiache
      namespace: ${kubernetes_namespace_v1.crossplane_system.metadata[0].name}
    spec:
      package: xpkg.upbound.io/upbound/provider-aws-elasticache:v1.17.0
  YAML
}

resource "kubectl_manifest" "crossplane_aws_elasticache_provider_config" {
  depends_on = [kubernetes_secret.aws_secret, kubectl_manifest.crossplane_aws_elasticache_provider]
  server_side_apply = true
  force_conflicts   = true
  wait = true
  yaml_body         = <<YAML
    apiVersion: aws.upbound.io/v1beta1
    kind: ProviderConfig
    metadata:
      name: default
      namespace: ${kubernetes_namespace_v1.crossplane_system.metadata[0].name}
    spec:
      credentials:
        source: Secret
        secretRef:
          namespace: crossplane-system
          name: ${kubernetes_secret.aws_secret.metadata[0].name}
          key: aws-secret
  YAML
}

//use kubenernetes provider to create a secret
resource "kubernetes_secret" "aws_secret" {
  metadata {
    name = "aws-secret"
    namespace = kubernetes_namespace_v1.crossplane_system.metadata[0].name
  }
  data = {
    "aws-secret" = <<EOF
[default]
aws_access_key_id = ${var.AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${var.AWS_SECRET_ACCESS_KEY}
aws_session_token = ${var.AWS_SESSION_TOKEN}
  EOF
  }
}