variable "lb_subnets" {
  type = "list"
}

variable "tg_name" {}

variable "lb_name" {}


variable "vpc" {}

resource "aws_lb_target_group" "best_buy_dev_tg" {
  name     = "${var.tg_name}-${var.appEnv}"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${var.vpc}"
}

resource "aws_lb" "best_buy_lb" {
  name               = "${var.lb_name}-${var.appEnv}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.instance_sg}"]
  subnets            = "${var.lb_subnets}"
  enable_deletion_protection = false
}

resource "aws_lb_listener" "best-buy-listner" {
  load_balancer_arn = "${aws_lb.best_buy_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.best_buy_dev_tg.arn}"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = "${aws_lb_target_group.best_buy_dev_tg.arn}"
  target_id        = "${aws_instance.best-buy-ca.id}"
  port             = 3000
}

