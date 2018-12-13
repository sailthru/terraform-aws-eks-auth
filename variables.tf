variable "cluster_id" {
  description = "The name/id of the EKS cluster."
}

variable "kubeconfig_name" {
  description = "Override the default name used for items kubeconfig."
  default     = ""
}

variable "kubeconfig_aws_authenticator_command" {
  description = "Command to use to to fetch AWS EKS credentials."
  default     = "aws-iam-authenticator"
}

variable "kubeconfig_aws_authenticator_command_args" {
  description = "Default arguments passed to the authenticator command. Defaults to [token -i $cluster_name]."
  type        = "list"
  default     = []
}

variable "kubeconfig_aws_authenticator_additional_args" {
  description = "Any additional arguments to pass to the authenticator such as the role to assume. e.g. [\"-r\", \"MyEksRole\"]."
  type        = "list"
  default     = []
}

variable "kubeconfig_aws_authenticator_env_variables" {
  description = "Environment variables that should be used when executing the authenticator. e.g. { AWS_PROFILE = \"eks\"}."
  type        = "map"
  default     = {}
}

variable "config_output_path" {
  description = "Where to save the Kubectl config file (if `write_kubeconfig = true`). Should end in a forward slash `/` ."
  default     = "./.terraform/"
}

variable "write_kubeconfig" {
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `config_output_path`."
  default     = true
}

variable "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
}

variable "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
}

variable "aws_authenticator_role_arn" {
  description = "Assume an IAM Role ARN before signing this token"
}

variable "aws_profile" {
  default = "default"
}
