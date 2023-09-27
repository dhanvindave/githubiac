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

resource "aws_transfer_server" "example" {
  logging_role = "arn:aws:iam::123456789012:role/S3Access" 
  endpoint_type = "VPC"

  endpoint_details {
    subnet_ids = [aws_subnet.example.id]
    vpc_id     = aws_vpc.example.id
  }

  protocols   = ["FTP", "FTPS"]
  certificate = aws_acm_certificate.example.arn

  identity_provider_type = "API_GATEWAY"
  url                    = "${aws_api_gateway_deployment.example.invoke_url}${aws_api_gateway_resource.example.path}"
}
