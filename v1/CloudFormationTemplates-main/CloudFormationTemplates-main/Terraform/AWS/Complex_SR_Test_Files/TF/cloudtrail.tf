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

data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "foobar" {
  sns_topic_name = "assa" 
  is_multi_region_trail = "true" 
  cloud_watch_logs_role_arn = "addas" 
  cloud_watch_logs_group_arn = "asdsd" 
  enable_log_file_validation = "true" 
  name                          = "tf-trail-foobar"
  s3_bucket_name                = aws_s3_bucket.foo.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

resource "aws_s3_bucket" "foo" {
  object_lock_enabled = "true" 
  bucket        = "tf-test-trail"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "foo" {
  bucket = aws_s3_bucket.foo.id
  acl    = "private"
}

resource "aws_s3_bucket" "log_bucket" {
  object_lock_enabled = "true" 
  bucket = "my-tf-log-bucket"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "foo" {
  bucket = aws_s3_bucket.foo.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

data "aws_iam_policy_document" "foo" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.foo.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.foo.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "foo" {
  bucket = aws_s3_bucket.foo.id
  policy = data.aws_iam_policy_document.foo.json
}

resource "aws_s3_bucket_public_access_block" "foo" {
  bucket = aws_s3_bucket.foo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "example" {
  object_lock_enabled = "true" 
  bucket = "my-tf-example-bucket"
}
