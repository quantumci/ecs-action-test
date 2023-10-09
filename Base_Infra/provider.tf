terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.64.0"
        }
    }
    backend "s3" {
      bucket = data.external.backend.result["bucket_name"]
      key = data.external.backend.result["bucket_key"]
      region = data.external.backend.result["bucket_region"]
    }
}

provider "aws" {
    region = var.aws_region

}
