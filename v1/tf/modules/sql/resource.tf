locals {
    val = var.monitoring
}

resource "aws_instance" "module_instance" {
  monitoring = local.val
  disable_api_termination = var.disable_api_termination
  ami = var.ami
}

resource "aws_instance" "module_instance_2" {
  monitoring = var.monitoring
  disable_api_termination = var.disable_api_termination
  ami = var.ami
}
