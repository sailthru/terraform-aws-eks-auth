# Terrafrom module that generates the EKS kubeconfig

Terraform module for generating AWS EKS configuration file and access token

This module re-uses the kubeconfig template and plan snippets from the official EKS module `terraform-aws-modules/eks/aws`

## Usage

```hcl
data "aws_eks_cluster" "this" {
  name = "my_eks_cluster"
}

data "aws_iam_role" "kubernetes_auth_role" {
  name = "eks_auth_role"
}

module "eks_auth" {
  source = "sailthru/eks-auth/aws"
  aws_profile = "default"
  cluster_id = "${data.aws_eks_cluster.this.id}"
  kubeconfig_aws_authenticator_additional_args = ["-r", "${data.aws_iam_role.kubernetes_auth_role.arn}"]
  cluster_endpoint = "${data.aws_eks_cluster.this.endpoint}"
  cluster_certificate_authority_data = "${data.aws_eks_cluster.this.certificate_authority.0.data}"
  aws_authenticator_role_arn = "${data.aws_iam_role.kubernetes_auth_role.arn}"
  kubeconfig_aws_authenticator_env_variables = {
    AWS_PROFILE = "default"
  }
}

provider kubernetes {
  config_path = "${module.eks_auth.kubeconfig_filename}"
  token = "${module.eks_auth.aws_authenticator_token}"
}

```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_authenticator_role_arn | Assume an IAM Role ARN before signing this token | string | - | yes |
| aws_profile | - | string | - | yes |
| cluster_certificate_authority_data | Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster. | string | - | yes |
| cluster_endpoint | The endpoint for your EKS Kubernetes API. | string | - | yes |
| cluster_id | The name/id of the EKS cluster. | string | - | yes |
| config_output_path | Where to save the Kubectl config file (if `write_kubeconfig = true`). Should end in a forward slash `/` . | string | `./.terraform/` | no |
| kubeconfig_aws_authenticator_additional_args | Any additional arguments to pass to the authenticator such as the role to assume. e.g. ["-r", "MyEksRole"]. | list | `<list>` | no |
| kubeconfig_aws_authenticator_command | Command to use to to fetch AWS EKS credentials. | string | `aws-iam-authenticator` | no |
| kubeconfig_aws_authenticator_command_args | Default arguments passed to the authenticator command. Defaults to [token -i $cluster_name]. | list | `<list>` | no |
| kubeconfig_aws_authenticator_env_variables | Environment variables that should be used when executing the authenticator. e.g. { AWS_PROFILE = "eks"}. | map | `<map>` | no |
| kubeconfig_name | Override the default name used for items kubeconfig. | string | `` | no |
| write_kubeconfig | Whether to write a Kubectl config file containing the cluster configuration. Saved to `config_output_path`. | string | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_authenticator_token | AWS EKS Authentication token |
| kubeconfig_filename | Generated kubeconfig file path |
