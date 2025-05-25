data "http" "my_public_ip" {
  url = "https://ifconfig.me/ip"
}
output "my_ip" {
  value = chomp(data.http.my_public_ip.response_body)
}

resource "aws_security_group" "bastion_sg" {
  name        = "ce-grp-1-bastion-sg"
  description = "Allow SSH access to bastion"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "Allow SSH from VPC internal range"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "ce-grp-1-bastion-sg"
    Project = "ce-grp-1"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

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

