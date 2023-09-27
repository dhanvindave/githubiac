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

resource "aws_emr_cluster" "example" {
  # ... other configuration ...
  master_instance_fleet {
    instance_type_configs {
      instance_type = "m4.xlarge"
    }
    target_on_demand_capacity = 1
  }
  core_instance_fleet {
    instance_type_configs {
      bid_price_as_percentage_of_on_demand_price = 80
      ebs_config {
        size                 = 100
        type                 = "gp2"
        volumes_per_instance = 1
      }
      instance_type     = "m3.xlarge"
      weighted_capacity = 1
    }
    instance_type_configs {
      bid_price_as_percentage_of_on_demand_price = 100
      ebs_config {
        size                 = 100
        type                 = "gp2"
        volumes_per_instance = 1
      }
      instance_type     = "m4.xlarge"
      weighted_capacity = 1
    }
    instance_type_configs {
      bid_price_as_percentage_of_on_demand_price = 100
      ebs_config {
        size                 = 100
        type                 = "gp2"
        volumes_per_instance = 1
      }
      instance_type     = "m4.2xlarge"
      weighted_capacity = 2
    }
    launch_specifications {
      spot_specification {
        allocation_strategy      = "capacity-optimized"
        block_duration_minutes   = 0
        timeout_action           = "SWITCH_TO_ON_DEMAND"
        timeout_duration_minutes = 10
      }
    }
    name                      = "core fleet"
    target_on_demand_capacity = 2
    target_spot_capacity      = 2
  }
}

resource "aws_emr_instance_fleet" "task" {
  cluster_id = aws_emr_cluster.example.id
  instance_type_configs {
    bid_price_as_percentage_of_on_demand_price = 100
    ebs_config {
      size                 = 100
      type                 = "gp2"
      volumes_per_instance = 1
    }
    instance_type     = "m4.xlarge"
    weighted_capacity = 1
  }
  instance_type_configs {
    bid_price_as_percentage_of_on_demand_price = 100
    ebs_config {
      size                 = 100
      type                 = "gp2"
      volumes_per_instance = 1
    }
    instance_type     = "m4.2xlarge"
    weighted_capacity = 2
  }
  launch_specifications {
    spot_specification {
      allocation_strategy      = "capacity-optimized"
      block_duration_minutes   = 0
      timeout_action           = "TERMINATE_CLUSTER"
      timeout_duration_minutes = 10
    }
  }
  name                      = "task fleet"
  target_on_demand_capacity = 1
  target_spot_capacity      = 1
}