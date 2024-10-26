variable "cidr-vpc" {
  description = "CIDR for your VPC"
  type        = string
}

variable "azs_list" {
  description = "List of your azs"
  type        = list(string)
}

variable "private-cidr" {
  description = "CIDR's of your Private subnets"
  type        = list(string)
}

variable "public-cidr" {
  description = "CIDR's of your Public subnets"
  type        = list(string)
}

variable "id_ami" {
  description = "Id from AMI" # "ami-077144d257f10bc90"
  type        = string
}

variable "manager_size_instance" {
  description = "Size of the EC2 manager instance"
  type        = string
}

variable "worker_size_instance" {
  description = "Size of the EC2 worker instance"
  type        = string
}

variable "asg_desired_size" {
  description = "Derired size for ASG"
  type        = number
}

variable "asg_max_size" {
  description = "Max size for ASG"
  type        = number
}

variable "asg_min_size" {
  description = "Min size for ASG"
  type        = number
}
