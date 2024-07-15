provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Creating a Random String
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

# Creating an S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = "mybucket-${random_string.random.result}"
  force_destroy = true
}

# Upload the object to the S3 bucket
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "sample.txt"
  source = "${path.module}/../files/sample.txt"
  etag   = filemd5("${path.module}/../files/sample.txt")
}

# Creating S3 Lifecycle Rules
resource "aws_s3_bucket_lifecycle_configuration" "rule" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id     = "transition-to-one-zone-ia"
    prefix = ""
    transition {
      days          = 30
      storage_class = "ONEZONE_IA"
    }
    expiration {
      days = 120
    }
    status = "Enabled"
  }

  rule {
    id     = "transition-to-glacier"
    prefix = ""
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    expiration {
      days = 120
    }
    status = "Enabled"
  }
}
