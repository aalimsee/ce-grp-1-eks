# create a ClusterRoleBinding that gives cluster-admin rights to the cluster-admins group.

# resource "kubernetes_cluster_role_binding" "cluster_admins_binding" {
#   metadata {
#     name = "ce-grp-1-admin-binding"
#   }

#   role_ref {
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#     api_group = "rbac.authorization.k8s.io"
#   }

#   subject {
#     kind      = "Group"
#     name      = "cluster-admins"
#     api_group = "rbac.authorization.k8s.io"
#   }
# }

# │ Error: clusterrolebindings.rbac.authorization.k8s.io is forbidden: User "arn:aws:iam::255945442255:user/aalimsee_ce9" cannot create resource "clusterrolebindings" in API group "rbac.authorization.k8s.io" at the cluster scope
# │ 
# │   with kubernetes_cluster_role_binding.cluster_admins_binding,
# │   on clusterrolebinding.tf line 3, in resource "kubernetes_cluster_role_binding" "cluster_admins_binding":
# │    3: resource "kubernetes_cluster_role_binding" "cluster_admins_binding" {
# │ 