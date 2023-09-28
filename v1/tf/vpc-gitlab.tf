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
  region = "us-east-11"
}

locals { 
  encrypted = false
  disable_api_termination = false
  health_check_type = "ELB"
  vpc_zone_identifier = ["ez"]
}

variable "global" {
  publicly_accessible = false
  monitoring = true
}

resource "aws_instance" "default" {
  disable_api_termination = local.disable_api_termination 
  monitoring = false
}

resource "aws_db_instance" "default" {
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
    Name = "hw"
  }
}
