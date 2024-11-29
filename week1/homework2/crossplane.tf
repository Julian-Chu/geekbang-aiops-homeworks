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

# resource "kubectl_manifest" "crossplane_aws_controller_config" {
#   depends_on = [helm_release.crossplane, module.crossplane_irsa_role]
#   server_side_apply = true
#   force_conflicts   = true
#   namespace = kubernetes_namespace_v1.crossplane_system.metadata[0].name
#   yaml_body         = <<YAML
#   apiVersion: pkg.crossplane.io/v1alpha1
#   kind: ControllerConfig
#   metadata:
#     name: aws-config
#     annotations:
#       eks.amazonaws.com/role-arn: ${module.crossplane_irsa_role.iam_role_arn}
#   spec:
#     podSecurityContext:
#       fsGroup: 2000
#     args:
#       - --poll=1437m
#       - --sync=336h
#   YAML
# }

# resource "kubectl_manifest" "aws_secret" {
#   server_side_apply = true
#   force_conflicts   = true
#   namespace = kubernetes_namespace_v1.crossplane_system.metadata[0].name
#   yaml_body         = <<YAML
#   apiVersion: v1
#   kind: Secret
#   metadata:
#     name: aws-secret
#     namespace: ${kubernetes_namespace_v1.crossplane_system.metadata[0].name}
#   type Opaque
#   data:
#     aws_access_key_id: ${var.AWS_ACCESS_KEY_ID}
#     aws_secret_access_key: ${var.AWS_SECRET_ACCESS_KEY}
#     aws_region: ${var.AWS_REGION}}
    
#   YAML
# }

//use kubenernetes provider to create a secret
resource "kubernetes_secret" "aws_secret" {
  metadata {
    name = "aws-secret"
    namespace = kubernetes_namespace_v1.crossplane_system.metadata[0].name
  }
  data = {
    aws_access_key_id = var.AWS_ACCESS_KEY_ID
    aws_secret_access_key = var.AWS_SECRET_ACCESS_KEY
    aws_region = var.AWS_REGION
  }
}