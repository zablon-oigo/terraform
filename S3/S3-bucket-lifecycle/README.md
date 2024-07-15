## How to Create an S3 Bucket lifecycle policy using Terraform
### Architecture diagram
![s3lifecycle](https://github.com/user-attachments/assets/4cbfbe46-6355-4c00-9a95-48f90d302df5)
### Create a variables file
- Create a file & name the file **variables.tf** and press Enter to save it
- Paste the contents below in variables.tf file
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
-Create another file and name the file **terraform.tfvars** and press Enter to save it.
- Paste the following into the terraform.tfvars file.
```
    region = "us-east-1"
    access_key = "<YOUR_ACCESS_KEY>"        
    secret_key = "<YOUR_SECRET_KEY>"
```
- In the above code, you are defining the dynamic values of variables declared earlier
- Replace the values of access_key and secret_key
- After replacing the values of access_key and secret_key, save the file by pressing Ctrl + S.
### Create an S3 Bucket in the main.tf file
- Create a file and name the file as **main.tf** and press Enter to save it.
- Paste the following content into the main.tf file.
```
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

```
- This code above  creates a unique S3 bucket by generating a random string and using it as part of the bucket name.
- Save the file by pressing Ctrl + S.
### Upload an Object in S3 Bucket in main.tf file 
- Create a folder and name the folder as **files**
- Create a new file inside **files folder** and name the file as **Sample.txt**
- Add simple text inside **sample.txt** i.e "Hello World!"
- Now Add another block just below the s3 bucket creation code in **main.tf** file, this block of code will upload the .txt file present under files folder to the S3 bucket.
```
# Upload the object to the S3 bucket
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "sample.txt"
  source = "${path.module}/../files/sample.txt"
  etag   = filemd5("${path.module}/../files/sample.txt")
}
```
### Create a LifeCycle Rule in main.tf file  
- To create a Lifecycle rule add another block of code just below the upload code code into the main.tf file
```
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
```
-  This code creates a lifecycle configuration for an S3 bucket that automatically transitions objects to lower-cost storage classes and expires them after a certain number of days
### Create an Output file
- Create a new file and  name the file as **output.tf** and press Enter to save it. Paste the following content to the **output.tf** file.
```
output "bucket" {
  value       = aws_s3_bucket.bucket.id         
}
output "object" {
  value       = aws_s3_object.object.id          
}
output "rule" {
  value       = aws_s3_bucket_lifecycle_configuration.rule.id           
}
```
- In the above code, we will extract details of resources created to confirm that they are created.
### Test and Apply terraform configurations
- Initialize Terraform by running
```
terraform init
```
- To generate the action plans run
```
terraform plan 
```
- To create all the resources declared in main.tf configuration file, run
```
terraform apply
```
- Approve the creation of all the resources by entering **yes**.
### To Delete AWS Resources
- Run the below command to delete all the resources.
```
terraform destroy
```
- Approve the deletion of all the resources by entering **yes**.
