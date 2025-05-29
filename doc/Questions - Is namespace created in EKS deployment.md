# Is EKS namespace dev, test, prod created in EKS deploy?

Great check-in — and here’s the answer:

❌ No — dev, test, and prod namespaces are not automatically created as part of your EKS setup in Step 2 (Terraform module).

✅ Why They’re Not Created
The terraform-aws-modules/eks/aws module creates the EKS cluster and node groups, but it does not create Kubernetes namespaces.

Kubernetes resources (like namespaces, deployments, services) must be applied after the cluster is provisioned — typically via:

kubectl apply
Helm
Argo CD
GitOps

✅ How to Create the Namespaces (manually or via YAML)
🧪 From Bastion EC2 (after aws eks update-kubeconfig):
bash
kubectl create ns dev
kubectl create ns test
kubectl create ns prod

✅ You can check them with:
bash
kubectl get ns

✅ Or with YAML (GitOps-ready)
yaml
# k8s/namespaces.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
---
apiVersion: v1
kind: Namespace
metadata:
  name: test
---
apiVersion: v1
kind: Namespace
metadata:
  name: prod

Apply:
bash
kubectl apply -f k8s/namespaces.yaml

✅ Best Practice (Argo CD Way)
If you're going GitOps, you’ll include namespace definitions in your app manifests or bootstrap Helm charts — and Argo CD will sync them into EKS.

Let me know if you'd like a workflow job or YAML manifest that auto-creates these namespaces as part of step 3 (Argo CD setup).