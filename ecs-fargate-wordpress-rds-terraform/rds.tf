resource "aws_db_subnet_group" "default" {
    name        = "wp-db-subnet-tf"
    description = "VPC Subnets"
    subnet_ids  = ["${aws_subnet.wp-public-a-tf.id}", "${aws_subnet.wp-public-b-tf.id}", "${aws_subnet.wp-public-c-tf.id}"]
}

resource "aws_db_instance" "db" {
    identifier           = "my-mariadb-db"
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mariadb"
    engine_version       = "10.11"
    port                 = "3306"
    instance_class       = "${var.db_instance_type}"
    db_name              = "${var.db_name}"
    username             = "${var.db_user}"
    password             = "${var.db_password}"
    multi_az             = false
    vpc_security_group_ids = ["${aws_security_group.wp-db-sg-tf.id}"]
    db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
    parameter_group_name = "default.mariadb10.11"
    publicly_accessible  = true
    skip_final_snapshot  = true
}