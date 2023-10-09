variable "aws_region" {
  default     = "us-east-1"
  description = "AWS REGION"
}

variable "environment" {
  default     = "DEV"
  description = "Environment name used a sprefix"
}

variable "bucket_name" {
  default = "pradip-bucket-ecs-111"
}

variable "platform_bucket_key" {
  default = "platform-infra/terraform.tfstate"
}

variable "bucket_region" {
  default = "us-east-1"
}

variable "base_remote_state_key" {
  default = "base/baseinfra.tfstate"
}