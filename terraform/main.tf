module "cluster_vpc" {
  source     = "./networking"
  cidr       = "" # Your VPC CIDR
  azs        = [] # Put your azs
  privatesub = [] # Put your private subnets CIDRs
  publicsub  = [] # Put your public subnets CIDRs
}
