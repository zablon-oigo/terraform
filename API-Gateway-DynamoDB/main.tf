provider "aws"{
    region=var.region
    access_key = var.access_key
    secret_key = var.secret_key
}
data "aws_vpc" "default"{
    default = true
}
data "aws_subnet" "subnet" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = "us-east-1a"
  
}
resource "aws_security_group" "sg" {
  name="test-sg"
  vpc_id = data.aws_vpc.default.id
  ingress {
    to_port=443
    from_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_vpc_endpoint" "vpcendpoint" {
  vpc_id             = data.aws_vpc.vpc.id
  subnet_ids         = [data.aws_subnet.subnet1.id]
  service_name       = "com.amazonaws.us-east-1.execute-api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.whiz_sg.id,]
  ip_address_type    = "ipv4"
}
resource "aws_dynamodb_table" "table" {
  name           = "test-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"
  attribute {
    name = "Id"
    type = "S" 
  }
  
}
resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.table.name
  hash_key   = aws_dynamodb_table.table.hash_key
  item = <<ITEM
{
  "Id": {"S": "1"},
  "Firstname": {"S": "John"},
  "LastName": {"S": "Doe"},
  "Age": {"S": "20"}
}
ITEM
}
resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.table.name
  hash_key   = aws_dynamodb_table.table.hash_key
  item = <<ITEM
{
  "Id": {"S": "2"},
  "Firstname": {"S": "Jane"},
  "LastName": {"S": "Doe"},
  "Age": {"S": "19"}
}
ITEM
}