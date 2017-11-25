# Variables
variable "key_name"{
    default = "ak_ec2_key"
}
variable instance_ami {}
variable instance_sg {}

#Providers

provider "aws" {}

resource "aws_instance" "kubernetes_master" {
  ami           = "${var.instance_ami}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.instance_sg}"]
  tags {
      Name = "Kubernetes-master"
  }
  count = 1
}

output "aws_instance_public_dns"{
    value = "${aws_instance.kubernetes_master.public_dns}"
}