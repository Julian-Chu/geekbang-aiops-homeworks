variable "cluster_name" {
  description = "The name of the kind cluster"
  type        = string
  default = "test-cluster"
}

variable "AWS_REGION" {
    description = "The AWS region to use"
    type        = string
    default = "eu-west-1"
}

variable "AWS_ACCESS_KEY_ID" {
    description = "The AWS access key ID"
    type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
    description = "The AWS secret access key"
    type        = string
}