variable "aws_region" {
    type = string
    default = "eu-west-1"
}

variable "instance-type" {
    type = string
    default ="t2.micro"
}
variable "ami_docker" {
    type = string
    default = "Docker-image"
}

variable "username" {
    type = string
    default = "ubuntu"
}

locals {
        timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}