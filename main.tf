provider "aws" { profile = "default" }

resource "aws_s3_bucket" "my-s3-bucket" {
  bucket_prefix = var.bucket_prefix
  
  tags = var.tags
}
