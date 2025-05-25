your EKS cluster is now accessible and working properly. Let's move on to Step 3: Install Argo CD (GitOps CD).

✅ Step 3: Install Argo CD on EKS
We’ll deploy Argo CD into its own namespace using Kubernetes manifests. Since cluster_endpoint_public_access = true, you can apply directly from your notebook.

1. Create Namespace for Argo CD
bash
kubectl create namespace argocd

2. Install Argo CD Manifests (Official)
bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
This will deploy the full Argo CD stack: API server, UI, controller, repo-server, etc.

3. Wait for All Pods to Be Ready
bash
kubectl get pods -n argocd
You should see all pods become Running. Wait until none are in Pending/CrashLoop.

4. (Optional) Expose Argo CD UI via Port Forward
To access the Argo CD UI from your local notebook:

bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
Then visit: https://localhost:8080

5. Login to Argo CD CLI (Optional)
Get the initial admin password:

bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d; echo
Then install Argo CD CLI (if needed):
https://argo-cd.readthedocs.io/en/stable/cli_installation/

And login:

bash
argocd login localhost:8080 --username admin --password <PASSWORD> --insecure
password - "-exaH5QD6mw2gVEI"