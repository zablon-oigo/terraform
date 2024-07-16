# Launch an EC2 Instance as a web server using Terraform
### Create a variables file
- Create a file & name the file **variables.tf** and press Enter to save it
- Paste the contents below in **variables.tf** file
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
### Create EC2 and its components in main.tf file
- Create a new file and name  the file **main.tf**
```
provider "aws" {
region = "${var.region}"
access_key = "${var.access_key}"
secret_key = "${var.secret_key}"
}
```
- In the above code, you are defining the provider as aws.
- Next, we want to tell Terraform to create a Security Group within AWS EC2, and populate it with rules to allow traffic on specific ports. In         our case, we are allowing the tcp port 80 (HTTP).
- We also want to make sure the instance can connect outbound on any port, so we’re including an egress section below as well.
- Paste the following into the main.tf file after the provider.
```
resource "aws_security_group" "web-server" {
name = "web-server"
description = "Allow incoming HTTP Connections" 
ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]         
}   
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]         
}           
}
```
