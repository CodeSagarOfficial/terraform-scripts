resource "aws_lb" "default" {
    name               = "wp-alb-tf"
    internal           = false
    load_balancer_type = "application"
    security_groups    = ["${aws_security_group.wp-alb-tf.id}"]
    subnets            = ["${aws_subnet.wp-public-a-tf.id}", "${aws_subnet.wp-public-b-tf.id}", "${aws_subnet.wp-public-c-tf.id}"]

    enable_deletion_protection = false

    tags = {
        Name = "wp-alb-tf"
    }
}

resource "aws_lb_target_group" "default" {
    name     = "wp-alb-tg-tf"
    port     = 80
    protocol = "HTTP"
    vpc_id      = "${aws_vpc.default.id}"
    target_type = "ip"

    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "default" {
    load_balancer_arn = "${aws_lb.default.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.default.arn}"
    }
}
