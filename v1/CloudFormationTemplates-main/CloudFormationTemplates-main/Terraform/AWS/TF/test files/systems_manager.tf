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

resource "aws_ssm_association" "example" {
  name = aws_ssm_document.example.name

  # Cron expression example
  schedule_expression = "cron(0 2 ? * SUN *)"

  # Single-run example
  # schedule_expression = "at(2020-07-07T15:55:00)"

  # Rate expression example
  # schedule_expression = "rate(7 days)"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.example.id]
  }
}