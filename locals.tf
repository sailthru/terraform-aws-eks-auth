locals {
  kubeconfig_name          = "${var.kubeconfig_name == "" ? "eks_${var.cluster_id}" : var.kubeconfig_name}"
}
