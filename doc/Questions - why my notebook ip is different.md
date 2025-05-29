Noticing a key difference between running Terraform manually vs. in GitHub Actions.

🔍 The Reason: GitHub Actions Runs in a Different Network
🟢 When you run locally:
Terraform runs from your machine

data "http" "my_public_ip" calls a public IP lookup service (like https://checkip.amazonaws.com)

It sees your real public IP, e.g., 203.0.113.45

🔴 When GitHub Actions runs:
It runs in GitHub's hosted runner, inside a shared AWS environment

The my_public_ip value it fetches is GitHub's own IP address range, not yours

🔧 Why This Affects You
If you're using:

hcl
cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
Then:

Terraform Run Location	CIDR Added to Security Group
Local (your Mac)	Your real IP (works)
GitHub Actions	GitHub runner IP (not your IP)

So your SSH or API requests won't work unless the IP matches your actual network.

✅ Solutions
✅ Option 1: Use terraform apply manually for bastion setup (good for dev)
Works reliably from your machine

Keeps IP limited to your current device

✅ Option 2: Hardcode trusted CIDRs (e.g., corporate IP, VPC CIDR)
hcl
cidr_blocks = ["14.0.0.0/16"]  # Your VPC range
or

hcl
cidr_blocks = ["203.0.113.0/24"]  # Your office range
✅ Option 3: Use a variable and override it per environment
In variables.tf:

hcl
variable "allowed_ip" {
  description = "Allowed CIDR block for SSH"
  type        = string
}
In main.tf:

hcl
cidr_blocks = [var.allowed_ip]
Then:

Use terraform apply -var="allowed_ip=203.0.113.45/32" locally

Or pass a GitHub Actions secret like TF_VAR_allowed_ip

✅ Summary
Mode	Public IP accuracy	Use case
Local CLI	✅ Accurate	Manual deploy
GitHub Actions	❌ GitHub IP	Automation only

Let me know if you'd like me to update your GitHub Actions workflow to accept an input variable for allowed_ip from Secrets or .tfvars file.