## How to host a S3 Static Website using Terraform
![S3](https://github.com/user-attachments/assets/296ddbc4-44ac-4b15-8d97-782328b43cf1)
### Create a variables file
- Create a file & name the file as **variables.tf** and press Enter to save it
- Paste the  contents below  in **variables.tf** file
```
variable "access_key" {
    description = "Access key to AWS console"
}
variable "secret_key" {
    description = "Secret key to AWS console"
}
variable "region" {
    description = "AWS region"
}
```

- In the above content, you are declaring a variable called, access_key, secret_key, and region with a short description of all 3.
- After pasting the above contents, save the file by pressing ctrl + S.
- Create another file and name the file terraform.tfvars and press Enter to save it.
- Paste the following into the **terraform.tfvars** file.
```
    region = "us-east-1"
    access_key = "<YOUR_ACCESS_KEY>"        
    secret_key = "<YOUR_SECRET_KEY>"
```
- In the above code, you are defining the dynamic values of variables declared earlier
- Replace the values of access_key and secret_key
- After replacing the values of access_key and secret_key, save the file by pressing Ctrl + S.
### Create an S3 and its components in main.tf file
Create a file and name the file **main.tf** and press Enter to save it
Paste the below content into the **main.tf** file.
```
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
# Creating a Random String #
resource "random_string" "random" {
  length = 6
  special = false
  upper = false
} 
# Creating an S3 Bucket #
resource "aws_s3_bucket" "bucket" {
  bucket = "myblogexample-${random_string.random.result}"
  force_destroy = true
}
resource "aws_s3_bucket_website_configuration" "blog" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```
- In the above code, you are defining the provider as AWS and provisioning AWS resources, including an S3 bucket, by configuring the AWS provider and using a random string resource to generate a unique bucket name. It also sets up the S3 bucket for website hosting and configures public access settings.
