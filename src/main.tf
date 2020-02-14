# AWSの設定
provider "aws" {
  region   = var.aws["region"]
  profile  = var.aws["profile"]
}


#VPCの作成
resource "aws_vpc" "of_docker_for_terraform"
  cidr_block = var.vpc_cider
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.vpc_name
  }

