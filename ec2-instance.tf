# Variables
variable "key_name"{
    default = "best-buy-ca"
}
variable instance_ami {}
variable instance_sg {}
variable launch_config_name {}
variable "iam_role" {}
variable "subnet_id" {}


variable appEnv {}

variable "port" {}

variable "docker_app_image" {}
variable "image_port" {}
variable "instance_port" {}

#Providers

provider "aws" {}

data "template_file" "init" {
  template = "${file("startUp.sh.tpl")}"

  vars = {
    docker_app_image = "${var.docker_app_image}"
    instance_port = "${var.instance_port}"
    image_port = "${var.image_port}"
    env = "${var.appEnv}"
    port = "${var.port}"
  }
}
resource "aws_instance" "best-buy-ca" {
  ami = "${var.instance_ami}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.instance_sg}"]
  iam_instance_profile = "developer"
  subnet_id = "${var.subnet_id}"
  user_data = "${data.template_file.init.rendered}"
  tags = {
      Name = "best-buy-${var.appEnv}"
  }
  
}

output "aws_instance_public_dns"{
    value = "${aws_instance.best-buy-ca.public_dns}"
}


