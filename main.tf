data "aws_region" "current" {}

data "template_file" "kubeconfig" {
  template = "${file("${path.module}/templates/kubeconfig.tpl")}"

  vars {
    kubeconfig_name                   = "${local.kubeconfig_name}"
    endpoint                          = "${var.cluster_endpoint}"
    region                            = "${data.aws_region.current.name}"
    cluster_auth_base64               = "${var.cluster_certificate_authority_data}"
    aws_authenticator_command         = "${var.kubeconfig_aws_authenticator_command}"
    aws_authenticator_command_args    = "${length(var.kubeconfig_aws_authenticator_command_args) > 0 ? "        - ${join("\n        - ", var.kubeconfig_aws_authenticator_command_args)}" : "        - ${join("\n        - ", formatlist("\"%s\"", list("token", "-i", var.cluster_id)))}"}"
    aws_authenticator_additional_args = "${length(var.kubeconfig_aws_authenticator_additional_args) > 0 ? "        - ${join("\n        - ", var.kubeconfig_aws_authenticator_additional_args)}" : ""}"
    aws_authenticator_env_variables   = "${length(var.kubeconfig_aws_authenticator_env_variables) > 0 ? "      env:\n${join("\n", data.template_file.aws_authenticator_env_variables.*.rendered)}" : ""}"
  }
}

data "template_file" "aws_authenticator_env_variables" {
  template = <<EOF
        - name: $${key}
          value: $${value}
EOF

  count = "${length(var.kubeconfig_aws_authenticator_env_variables)}"

  vars {
    value = "${element(values(var.kubeconfig_aws_authenticator_env_variables), count.index)}"
    key   = "${element(keys(var.kubeconfig_aws_authenticator_env_variables), count.index)}"
  }
}

resource "local_file" "kubeconfig" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "${var.config_output_path}kubeconfig_${var.cluster_id}"
}

data "external" "aws_iam_authenticator" {
  program = ["bash", "${path.module}/authenticator.sh"]

  query {
    profile      = "${var.aws_profile}"
    cluster_name = "${var.cluster_id}"
    role         = "${var.aws_authenticator_role_arn}"
  }
}
