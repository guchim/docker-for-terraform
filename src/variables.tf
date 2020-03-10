variable "aws" {
  default = {
    profile = "default"
    region  = "ap-northeast-1"
  }
}


variable "vpc_cider"{
  type = string
  default = "10.0.0.0/16"
  description = "VPCのCIDR"
}


variable "vpc_name" {
  type = string
  default = "terraform_on_docker_vpc"
  description = "VPCの名前"
}


variable "az_names" {
  type = map(string)
  default = {
    "1a" = "ap-northeast-1a"
    "1c" = "ap-northeast-1c"
  }
  description = "Averability_zoneの名前"
}


variable "public_subnet_1a_name" {
  type        = string
  default     = "terraform_on_docker_public_subnet_1a"
  description = "パブリックサブネット1aの名前"
}


variable "public_subnet_1c_name" {
  type        = string
  default     = "terraform_on_docker_public_subnet_1c"
  description = "パブリックサブネット1cの名前"
}


variable "private_subnet_1a_name" {
  type        = string
  default     = "terraform_on_docker_private_subnet_1a"
  description = "プライベートサブネット1a名前"
}


variable "private_subnet_1c_name" {
  type        = string
  default     = "terraform_on_docker_private_subnet_1c"
  description = "プライベートサブネット1c名前"
}


variable "igw_name" {
  type        = string
  default     = "terraform_on_docker_igw"
  description = "インターネットゲートウェイの名前"
}


variable "route_table_name" {
  type        = string
  default     = "terraform_on_docker_public_route"
  description = "ルートテーブルの名前"
}


variable "cidr_block_1" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDRのデフォルトのIPアドレス"
}


variable "cidr_block_2" {
  type        = list(string)
  default     = ["::/0"]
  description = "CIDRのデフォルトのIPアドレス"
}


variable "web_sg_name" {
  type        = string
  default     = "terraform_on_docker_web_sg"
  description = "ウェブのセキュリティグループの名前"
}


variable "aws_key_name" {
  type        = string
  default     = "terraform_on_docker"
  description = "EC2インスタンスにSSHでアクセスする際に使用するKey名"
}


variable "instance_name" {
  type        = string
  default     = "terraform_on_docker_ec2"
  description = "EC2インスタンスの名前"
}


variable "db_name" {
  type        = string
  default     = "terraform-on-docker-db"
  description = "データベースの名前"
}


variable "db_user_name" {
  type        = string
  default     = "admin"
  description = "データベースのユーザーの名前"
}


variable "db_user_password" {
  type        = string
  default     = "db_password"
  description = "データベースのユーザーのパスワード"
}


variable "rds_sg_name" {
  type        = string
  default     = "terraform_on_docker_db_sg"
  description = "データベースのセキュリティグループの名前"
}


variable "db_subnet_group_name" {
  type        = string
  default     = "terraform_on_docker_rds_subnet_group"
  description = "RDSサブネットグループの名前"
}


variable "alb_sg_name" {
  type        = string
  default     = "terraform_on_docker_alb_sg"
  description = "ロードバランサーのセキュリティグループの名前"
}


variable "alb_name" {
  type        = string
  default     = "terraform-on-docker-alb"
  description = "ロードバランサーの名前"
}


variable "alb_tg_name" {
  type        = string
  default     = "terraform-on-docker-alb-tg"
  description = "ロードバランサーのターゲットグループの名前"
}
