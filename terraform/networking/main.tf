module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cluster_vpc"
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.privatesub
  public_subnets  = var.publicsub

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
