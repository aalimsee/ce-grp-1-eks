# Creates Kubernetes ServiceAccount external-dns in kube-system with IRSA annotation

resource "kubernetes_service_account" "externaldns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.externaldns_irsa.arn
    }
  }
}

