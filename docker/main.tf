provider "aws" {
    region = "${var.region}"
    secret_key = "${var.secret_key}"
    access_key = "${var.access_key}"
    token="${var.token}"
}
