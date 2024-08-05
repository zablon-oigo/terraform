## How to create and configure an AWS Network LoadBalancer using Terraform
###  Create a variable file
- Create a file and name the file **variables.tf** and press Enter to save it
- Paste the contents below into variables.tf file
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
- In the above content, you are declaring a variable called, **access_key**, **secret_key**, and **region** with a short description of all 3.
- After pasting the above contents, save the file by pressing ctrl + S.
- Create another file and name the file **terraform.tfvars** and press Enter to save it.
- Paste the following into the **terraform.tfvars** file.
```
    region = "us-east-1"
    access_key = "<YOUR_ACCESS_KEY>"        
    secret_key = "<YOUR_SECRET_KEY>"
```
- In the above code, you are defining the dynamic values of variables declared earlier
- Replace the values of access_key and secret_key
- After replacing the values of access_key and secret_key, save the file by pressing Ctrl + S.
