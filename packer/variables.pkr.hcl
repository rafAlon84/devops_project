variable "aws_region" {
    type = string
    default = "eu-west-1"
}

variable "instance-type" {
    type = string
    default ="t2.micro"
}
variable "ami_manager" {
    type = string
    default = "Docker-manager"
}

variable "ami_worker" {
    type = string
    default = "Docker_worker"
}

variable "username" {
    type = string
    default = "ubuntu"
}

locals {
        timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}