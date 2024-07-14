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
- Add another block of just below the s3 bucket public access code, this block of code will upload all the files present under HTML folder to the S3 bucket
```
resource "aws_s3_object" "upload_object" {
  for_each      = fileset("${path.module}/../html", "*")
  bucket        = aws_s3_bucket.bucket.bucket
  key           = each.value
  source        = "${path.module}/../html/${each.value}"
  etag          = filemd5("${path.module}/../html/${each.value}")
  content_type  = "text/html"
}
```
- Finally, make the bucket public by adding the bucket policy by adding another block of code to the main.tf file.
```
resource "aws_s3_bucket_policy" "read_access_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}
```
### Create a HTML markup template
- create a folder and name it **html**
- inside html folder add **index.html** file and  **error.html** file
- add simple content in both file
### Display the output
- Create an outputs.tf file required for displaying the output as website endpoint.
- Paste the following inside **output.tf** file
```
output "s3_bucket_id" {
  value = aws_s3_bucket_website_configuration.blog.website_endpoint
}
```
### Apply terraform configurations
- Initialize Terraform by running:
```
 terraform init
```
*terraform init will check for all the plugin dependencies and download them if required, this will be used for creating a deployment plan.*
- To generate the action plans, run
```
terraform plan
```
- To create all the resources declared in main.tf configuration file, run
```
terraform apply  
```
You will be able to see the resources which will be created, approve the creation of all the resources by entering **yes**.
### Delete AWS Resources
To delete the resources run 
```
terraform destroy
```
