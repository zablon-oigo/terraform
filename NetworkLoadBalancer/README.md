## How to create and configure an AWS Network LoadBalancer using Terraform
### Architecture Diagram
![network](https://github.com/user-attachments/assets/490a4eac-2059-44a5-8a17-5e38f680dc90)
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
- In the above code, you are declaring a variable called, **access_key**, **secret_key**, and **region** with a short description of all 3.
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
### Launch an EC2 Instance in main.tf file
- Create a new file and name the file  **main.tf**
```
provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}			
```
- In the above code, you are defining the provider as AWS.
- Next, we want to tell Terraform to create a data source to get the details of vpc_id and subnet_id’s.
```
data "aws_vpc" "vpc" {
    default = true
}

data "aws_subnet" "subnet1" {
    vpc_id = data.aws_vpc.vpc.id
    availability_zone = "us-east-1a"
}

data "aws_subnet" "subnet2" {
    vpc_id = data.aws_vpc.vpc.id
    availability_zone = "us-east-1b"
}
```
