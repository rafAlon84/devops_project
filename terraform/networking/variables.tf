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

