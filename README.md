# ce-grp-1-eks
Capstone project cohort 9

# Issue #1
Medium Severity Issues: 2

  [Medium] Security Group allows open ingress
  Info:    That inbound traffic is allowed to a resource from any source instead
           of a restricted range. That potentially everyone can access your
           resource
  Rule:    https://security.snyk.io/rules/cloud/SNYK-CC-TF-1
  Path:    input > resource > aws_security_group[bastion_sg] > ingress
  File:    terraform/eks/ec2-bastion.tf
  Resolve: Set `cidr_block` attribute with a more restrictive IP, for example
           `192.16.0.0/24`

  [Medium] Non-Encrypted root block device
  Info:    The root block device for ec2 instance is not encrypted. That should
           someone gain unauthorized access to the data they would be able to
           read the contents.
  Rule:    https://security.snyk.io/rules/cloud/SNYK-CC-TF-53
  Path:    resource > aws_instance[bastion] > root_block_device > encrypted
  File:    terraform/eks/ec2-bastion.tf
  Resolve: Set `root_block_device.encrypted` attribute to `true`

# Fix Issue #1
🔴 1. Open Ingress on Security Group
Snyk: Security Group allows open ingress

🔧 Problem
You're currently doing something like:

h
cidr_blocks = ["0.0.0.0/0"]
This allows the entire internet to SSH into your EC2 — risky.

✅ Fix
Replace that with a restricted IP or your VPC CIDR:

h
cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
Or for your IP only (for dev testing):

hcl
cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
If you haven't already, make sure vpc_cidr_block is exported from the VPC module via outputs.tf.

🔴 2. Unencrypted Root Block Device
Snyk: Non-Encrypted root block device

🔧 Problem
EC2's root block device is not encrypted.

✅ Fix
Add this block to your EC2 instance resource:

hcl
root_block_device {
  encrypted = true
}

✅ Final EC2 Bastion Instance Example
hcl
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  key_name                    = "ce-grp-1-keypair"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  root_block_device {
    encrypted = true
  }

  tags = {
    Name    = "ce-grp-1-bastion"
    Project = "ce-grp-1"
  }
}

# Issue #2
│ Warning: Argument is deprecated
│ 
│   with module.eks.aws_iam_role.this[0],
│   on .terraform/modules/eks/main.tf line 387, in resource "aws_iam_role" "this":
│  387: resource "aws_iam_role" "this" {
│ 
│ inline_policy is deprecated. Use the aws_iam_role_policy resource instead. If Terraform should exclusively manage
│ all inline policy associations (the current behavior of this argument), use the aws_iam_role_policies_exclusive
│ resource as well.


# Fix Issue #2
You're seeing this warning because:

🔴 The inline_policy argument inside aws_iam_role has been deprecated in recent versions of the AWS provider (v5+).

✅ What It Means
Previously, you could define inline IAM policies directly inside the aws_iam_role block using:

hcl
inline_policy {
  name = "inline"
  policy = jsonencode({ ... })
}
This is now deprecated. The AWS provider recommends:

✅ Use a separate aws_iam_role_policy resource

🔁 If you want to fully control all inline policies, use the new resource:

aws_iam_role_policies_exclusive (to delete unmanaged ones)

✅ What You Can Do
If you're using a module (like terraform-aws-modules/eks/aws), and this warning points inside .terraform/modules/eks/main.tf, then:

✅ You don't need to fix this yourself — it’s coming from the module.

🛠 To suppress the warning cleanly:
You have two choices:

✅ Option 1: Ignore the warning (safe for now)
It’s not breaking

The module maintainers will likely update this in a future release

✅ Safe to continue using the module.

✅ Option 2: Update module if needed
Check if a newer version of terraform-aws-modules/eks/aws removes this:

hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4" # ← check for newer version
  ...
}
Check the module changelog to see if the warning has been addressed.

✅ Option 3: Custom override (advanced)
If you must eliminate the warning immediately and have control of your own aws_iam_role resources, move any inline_policy block out to a dedicated resource:

hcl
resource "aws_iam_role_policy" "example" {
  name = "example-inline"
  role = aws_iam_role.example.name
  policy = jsonencode({ ... })
}
✅ Summary
Option	Recommended?	Notes
Ignore warning	✅ Yes	Harmless for now
Upgrade module version	✅ Yes	If new version removes inline_policy
Manual fix in own code	⚠️ Maybe	Only needed if not using a module

