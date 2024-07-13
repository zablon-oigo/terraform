## How to Create DynamoDB Table and Insert Items to the table using Terraform

![Dynamo](https://github.com/user-attachments/assets/68b50c42-c754-473c-9481-7c324b5c5966)
### Create a variables file
- Name the file as variables.tf and press Enter to save it
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

