variable "ami_id" {
  description = "ID from de EC2 AMI"
  type        = string
}

variable "size_instance_manager" {
  description = "Size of the EC2 manager instance"
  type        = string
}

variable "size_instance_worker" {
  description = "Size of the EC2 worker instance"
  type        = string
}

variable "azs_ids" {
  description = "Azs id"
  type        = list(string)
}

variable "asg_desired" {
  description = "Derired capacity for the ASG"
  type        = number
}

variable "asg_max" {
  description = "Max capacity for the ASG"
  type        = number
}

variable "asg_min" {
  description = "Min capacity for the ASG"
  type        = number
}

variable "manager_id_sg" {
  description = "Id from manager sg"
  type        = string
}

variable "worker_id_sg" {
  description = "Id from worker sg"
  type        = string
}

variable "private_subnet" {
  description = "Private subnet ID"
  type        = string
}
