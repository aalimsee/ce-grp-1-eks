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
