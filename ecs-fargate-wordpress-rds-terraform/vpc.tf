# VPC
resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_hostnames = true
    
    tags = {
       Name = "wp-pvc-tf"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"

    tags = {
       Name = "wp-igw-tf"
    }
}

# Subnets
resource "aws_subnet" "wp-public-a-tf" {
    vpc_id            = "${aws_vpc.default.id}"
    cidr_block        = "${var.public_subnet_a_cidr_block}"
    availability_zone = "${var.zone1}"

    tags = {
       Name = "wp-public-a-tf"
    }
}

resource "aws_subnet" "wp-public-b-tf" {
    vpc_id            = "${aws_vpc.default.id}"
    cidr_block        = "${var.public_subnet_b_cidr_block}"
    availability_zone = "${var.zone2}"

    tags = {
       Name = "wp-public-b-tf"
    }
}

resource "aws_subnet" "wp-public-c-tf" {
    vpc_id            = "${aws_vpc.default.id}"
    cidr_block        = "${var.public_subnet_c_cidr_block}"
    availability_zone = "${var.zone3}"

    tags = {
       Name = "wp-public-c-tf"
    }
}

# Route Tables
resource "aws_route_table" "wp-rt-public-tf" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags = {
       Name = "wp-rt-public-tf"
    }
}

resource "aws_route_table_association" "a" {
    subnet_id = "${aws_subnet.wp-public-a-tf.id}"
    route_table_id = "${aws_route_table.wp-rt-public-tf.id}"
}

resource "aws_route_table_association" "b" {
    subnet_id = "${aws_subnet.wp-public-b-tf.id}"
    route_table_id = "${aws_route_table.wp-rt-public-tf.id}"
}

resource "aws_route_table_association" "c" {
    subnet_id = "${aws_subnet.wp-public-c-tf.id}"
    route_table_id = "${aws_route_table.wp-rt-public-tf.id}"
}