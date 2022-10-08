module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.3"

  name = "vpc_main"
  cidr = "10.0.0.0/19"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  private_subnet_tags = {
    Name = "${var.tag}-private"
  }

  public_subnet_tags = {
    Name = "${var.tag}-public"
  }

  tags = {
    Name = var.tag
  }

}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["${var.tag}-public"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.tag}-private"]
  }
}

