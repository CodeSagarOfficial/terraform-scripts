output "elb_dns" {
    value = "${aws_lb.default.dns_name}"
}