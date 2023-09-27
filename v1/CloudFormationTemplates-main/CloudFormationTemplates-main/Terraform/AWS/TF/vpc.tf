terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider 
provider "aws" {  

  region = "us-east-1"
}

variable "function_s3_bucket" {
  type = string
  default = "shared"
}

variable "function_zipfile" {
  type    = string
  default = "artifact.zip"
}

variable "comment_prefix" {
  type    = string
  default = "ignore"
}

variable "api_domain" {
  type    = string
  default = "threatmodeler"
}

locals {
  prefix_with_domain = "https"
}

variable function_timeout {
  type = number
  default = 30
}

variable "memory_size" {
  default = 5
}

variable "tags" {
  type = list(object( {
    key = string
    value = string
  }))
  default = list(object({
    key = "key"
    value = "value"
  }))
}

locals { 
  encrypted = false
  disable_api_termination = true
  health_check_type = "ELB"
  vpc_zone_identifier = ["ez"]
}

variable "global" {
  publicly_accessible = true
  monitoring = true
}

resource "aws_instance" "default" {
  disable_api_termination = local.disable_api_termination 
  monitoring = true
}

resource "aws_autoscaling_group" "default" {
  health_check_type = local.health_check_type
  default_cooldown = null
  vpc_zone_identifier = local.vpc_zone_identifier
  load_balancers = "empty"
  //target_group_arns = []
}

resource "aws_autoscaling_notification" "default" {
  group_names = [ "value" ]
  notifications = [ "autoscaling:EC2_INSTANCE_LAUNCH",
                     "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
                     "autoscaling:EC2_INSTANCE_TERMINATE",
                     "autoscaling:EC2_INSTANCE_TERMINATE_ERROR" ]
  topic_arn = ""
}

resource "aws_db_instance" "default" {
  resource =         {
            "engine": "mariadb",
            "enabled_cloudwatch_logs_exports": "audit"    
} 
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  max_allocated_storage = 100
  storage_encrypted = true
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size = 40
  encrypted = false
  tags = {
    Name = "HelloWorld"
  }
}

# Terraform isn't particularly helpful when you want to depend on the existence of a resource which may have count 0 or 1, like our functions.
# This is a hacky way of referring to the properties of the function, regardless of which one got created.
# https://github.com/hashicorp/terraform/issues/16580#issuecomment-342573652
locals {
  function_id         = "${element(concat(aws_lambda_function.local_zipfile.*.id, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.id, list("")), 0)}"
  function_arn        = "${element(concat(aws_lambda_function.local_zipfile.*.arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.arn, list("")), 0)}"
  function_invoke_arn = "${element(concat(aws_lambda_function.local_zipfile.*.invoke_arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.invoke_arn, list("")), 0)}"
}
