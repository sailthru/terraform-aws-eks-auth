output "aws_authenticator_token" {
  value = "${data.external.aws_iam_authenticator.result["token"]}"
  description = "AWS EKS Authentication token"
}

output "kubeconfig_filename" {
  value = "${local_file.kubeconfig.filename}"
  description = "Generated kubeconfig file path"
}
