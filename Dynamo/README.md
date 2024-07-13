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

