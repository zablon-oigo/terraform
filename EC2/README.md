# Launch an EC2 Instance as a web server using Terraform
### Architecture Diagram
![EC2](https://github.com/user-attachments/assets/fe39c1e1-7b70-43c7-b5fd-2f204ddccdbb)
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
- Finally, to complete the **main.tf** file, let's add another set of code after security group creation where you will create an EC2 instance.
```
resource "aws_instance" "web-server" {
ami = "ami-02e136e904f3da870"
instance_type = "t2.micro"
security_groups = ["${aws_security_group.web-server.name}"]
user_data = <<-EOF
#!/bin/bash 
sudo su
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "<html><h1> Hello Happy Learning... </h1></html>" >> /var/www/html/index.html       
EOF 
tags = {
Name = "EC2-instance"           
}           
}
```
- In the above code, we have defined the Amazon Linux 2 AMI. The AMI ID mentioned above is for the US-east-1 region.
- We have added the user data to install the apache server.
- We have provided tags for the EC2 instance.
- Save the file by pressing Ctrl + S.
### Create an Output file
- Create a new file and name the file **output.tf**
- Paste the following into the **output.tf** file.
```
output "web_instance_ip" {
value = aws_instance.web-server.public_ip           
}
```
### Apply terraform configurations
- Initialize Terraform by running
```
terraform init
```
- To generate the action plans run
```
terraform plan
```
- To create all the resources declared in main.tf configuration file run
```
terraform apply
```
### Delete AWS Resources
- To delete the resources, open Terminal again.
```
terraform destroy
```
