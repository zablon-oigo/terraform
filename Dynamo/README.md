## How to Create DynamoDB Table and Insert Items to the table using Terraform
### Architecture Diagram
![AWSDynamo](https://github.com/user-attachments/assets/7429c9c8-d790-4080-9bdf-9be4e1a4b274)


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
- In the above code , we are telling terraform to create a table with table name as example-table. The billing mode should be **provisioned** by default
- One read capacity unit describes the one strongly consistent read per second upto 1 KB in size.
- One write capacity unit describes the one strongly consistent write per second upto 1 KB in size.
- Hash_key represents the partition key of an item. It is composed of one attribute that acts as a primary key for the table.
- We have defined RollNo. as the primary attribute which will be an integer. Therefore we have declared the type as “N”.

### Adding items to the DynamoDB Table
- In this task, we are going to add items to the DynamoDB Table in the main.tf file.
- To add items to the table, paste the following content in the main.tf.
```
resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key
  item = <<ITEM
{
  "RollNo.": {"N": "1"},
  "Name": {"S": "John"}
}
ITEM
}
resource "aws_dynamodb_table_item" "item2" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key
  item = <<ITEM
{
  "RollNo.": {"N": "2"},
  "Name": {"S": "Jane"}
}
ITEM
}

resource "aws_dynamodb_table_item" "item3" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key
  item = <<ITEM
{
  "RollNo.": {"N": "3"},
  "Name": {"S": "Bob"}
}
ITEM
}
```
### Create an output file
- In this task, you will create an output.tf file where you will add details of the provider and resources.
- Create a new file and  name the file as **output.tf**  and press Enter to save it.
- Paste thecontent below into the **output.tf** file
```
output "table_arn1" {
    value = aws_dynamodb_table.dynamodb_table.arn
    description = "DynamoDB Table created successfully"
}
```
### Applying terraform configurations 
Initialize Terraform by running the  command
```
terraform init

```
To generate the action plans run the command
```
terraform plan

```
To create all the resources declared in main.tf configuration file, run the following command
```
terraform apply

```
Enter yes and the resources will be created

**Check the resources in the AWS Console**
### Delete AWS Resources
To delete the resources, open Terminal again.
Run the command to delete all the resources.
```
terraform destroy

```
Enter yes to confirm the deletion.
