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

resource "aws_lb" "web" {
  name            = "${local.prefix}-alb"
  subnets         = local.public_subnets
  security_groups = [module.alb_sg.security_group_id]
  tags = merge(
    {
      Name = "${local.prefix}-alb"
    },
    local.common_tags
  )
}

output "alb_arn" {
  value = aws_lb.web.arn
}

resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = local.alb_arn
  web_acl_arn  = module.waf.arn
}