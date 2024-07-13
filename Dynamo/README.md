## How to Create DynamoDB Table and Insert Items to the table using Terraform

![Dynamo](https://github.com/user-attachments/assets/68b50c42-c754-473c-9481-7c324b5c5966)
### Create a variables file
- Create a file & name the file as **variables.tf** and press Enter to save it
- Paste the below contents in variables.tf file

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
- Create another file and  name the file  **terraform.tfvars** and press Enter to save it.
- Paste the following into the terraform.tfvars file.
```
    region = "us-east-1"
    access_key = "<YOUR_ACCESS_KEY>"        
    secret_key = "<YOUR_SECRET_KEY>"
```
- In the above code, you are defining the dynamic values of variables declared earlier
- Replace the values of access_key and secret_key
- After replacing the values of access_key and secret_key, save the file by pressing Ctrl + S.

###  Create a DynamoDB Table and its components in main.tf file
- Create a file and name the file **main.tf** and press Enter to save it
- Paste the below content into the main.tf file.
```
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

```
- In the above code, you are defining the provider as AWS
- Next, we want to tell Terraform to create a DynamoDB table named as **example-table** .
- Paste the content below  into the main.tf file after the provider.
```
resource "aws_dynamodb_table" "dynamodb_table" {
  name           = "example-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "RollNo."

  attribute {
    name = "RollNo."
    type = "N"
  }
}
```
