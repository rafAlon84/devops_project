variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "privatesub" {
  type = list(string)
}

variable "publicsub" {
  type = list(string)
}

variable "target_id_attach" {
  description = "ID from ec2 objetive attach"
  type        = string
}
