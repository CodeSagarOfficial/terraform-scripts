# Create EC2 Instance With Terraform

# init Providers
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
```

# Init AWS
```hcl
provider "aws" {
    region = "your-region"
    access_key = "your-access-key"
    secret_key = "your-secret-key"
}
```

# Generate PEM File
```hcl
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

```hcl
variable "key_name" {
  description = "Name of the SSH key pair"
}
```

# Generate Key Pair
```hcl
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}
```

# Save PEM File
```hcl
resource "local_file" "private_key" {
    content = tls_private_key.rsa_4096.private_key_pem
    filename = var.key_name
}
```

# Create a security group
```hcl
resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

# Create EC2 instnace
```hcl
resource "aws_instance" "public_instance" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  tags = {
    Name = "public_instance"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
}
```

# Terraform Commands
```hcl
// Init Terraform
terraform init

// Review Plan
terraform plan

// Run Terraform Script
terraform apply

// Destroy Changes
terraform destroy
```