// sg for RDS
resource "aws_security_group" "wp-db-sg-tf" {
    name        = "wp-db-tf"
    description = "Access to the RDS instances"
    vpc_id      = "${aws_vpc.default.id}"

    ingress {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "wp-db-sg-tf"
    }
}

// sg for ALB
resource "aws_security_group" "wp-alb-tf" {
    name        = "wp-sg-alb-tf"
    description = "Security Group for the ALB"
    vpc_id      = "${aws_vpc.default.id}"

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "wp-sg-alb-tf"
    }
}