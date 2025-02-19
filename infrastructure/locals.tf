provider "aws" {
  region     = "us-east-2" # Change this to your desired region
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  endpoints {
    apigateway     = local.localstack_host
    apigatewayv2   = local.localstack_host
    cloudformation = local.localstack_host
    cloudwatch     = local.localstack_host
    dynamodb       = local.localstack_host
    ec2            = local.localstack_host
    es             = local.localstack_host
    firehose       = local.localstack_host
    iam            = local.localstack_host
    kinesis        = local.localstack_host
    lambda         = local.localstack_host
    rds            = local.localstack_host
    redshift       = local.localstack_host
    route53        = local.localstack_host
    s3             = local.s3_bucket_host
    secretsmanager = local.localstack_host
    ses            = local.localstack_host
    sns            = local.localstack_host
    sqs            = local.localstack_host
    ssm            = local.localstack_host
    stepfunctions  = local.localstack_host
    sts            = local.localstack_host
  }
}

locals {
  localstack_host = "http://localhost:4566"
  s3_bucket_host  = "http://s3.localhost.localstack.cloud:4566"
}


data "aws_region" "current" {}