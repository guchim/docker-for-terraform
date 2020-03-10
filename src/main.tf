# AWSの設定
provider "aws" {
  region   = var.aws["region"]
  profile  = var.aws["profile"]
}


#VPCの作成
resource "aws_vpc" "of_terraform_on_docker" {
  cidr_block           = var.vpc_cider
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.vpc_name
  }
}


#パブリックサブネット1aの定義
resource "aws_subnet" "of_public_1a" {
  cidr_block              = "10.0.10.0/24"
  vpc_id                  = aws_vpc.of_terraform_on_docker.id
  availability_zone       = var.az_names["1a"]
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_1a_name
  }
}


#パブリックサブネット1cの定義
resource "aws_subnet" "of_public_1c" {
  cidr_block              = "10.0.11.0/24"
  vpc_id                  = aws_vpc.of_terraform_on_docker.id
  availability_zone       = var.az_names["1c"]
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_1c_name
  }
}



#プライベートサブネット1aの定義
resource "aws_subnet" "of_private_1a" {
  cidr_block              = "10.0.20.0/24"
  vpc_id                  = aws_vpc.of_terraform_on_docker.id
  availability_zone       = var.az_names["1a"]
  map_public_ip_on_launch = false
  tags = {
    Name = var.private_subnet_1a_name
  }
}


#プライベートサブネット1cの定義
resource "aws_subnet" "of_private_1c" {
  cidr_block              = "10.0.21.0/24"
  vpc_id                  = aws_vpc.of_terraform_on_docker.id
  availability_zone       = var.az_names["1c"]
  map_public_ip_on_launch = false
  tags = {
    Name = var.private_subnet_1c_name
  }
}


#インターネットゲートウェイの定義
resource "aws_internet_gateway" "of_public"{
  vpc_id = aws_vpc.of_terraform_on_docker.id
  tags = {
    Name = var.igw_name
  }
}


# ルートテーブルの定義
resource "aws_route_table" "of_public" {
  vpc_id       = aws_vpc.of_terraform_on_docker.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.of_public.id
  }
  tags = {
    Name = var.route_table_name
  }
}


# ルートテーブルとサブネットの紐付け
resource "aws_route_table_association" "of_public_1a" {
  route_table_id = aws_route_table.of_public.id
  subnet_id = aws_subnet.of_public_1a.id
}


# セキュリティグループの定義
resource "aws_security_group" "for_web" {
  name          = var.web_sg_name
  vpc_id        = aws_vpc.of_terraform_on_docker.id
  description   = "Define of SG for public"
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = var.cidr_block_1
  }
  tags = {
    Name = var.web_sg_name
  }
}


# セキュリティグループルール(SSHのインバウンド)の定義
resource "aws_security_group_rule" "of_ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.for_web.id
  to_port           = 22
  cidr_blocks       = var.cidr_block_1
  description       = "ssh inbound of SG for public"
}


# セキュリティグループルール(HTTPのインバウンド)の定義
resource "aws_security_group_rule" "of_http_ingress_1" {
  type              = "ingress"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.for_web.id
  to_port           = 80
  cidr_blocks       = var.cidr_block_1
  description       = "http inbound of SG for public"
}


# セキュリティグループルール(HTTPのインバウンド)の定義
resource "aws_security_group_rule" "of_http_ingress_2" {
  type              = "ingress"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.for_web.id
  to_port           = 80
  ipv6_cidr_blocks  = var.cidr_block_2
  description       = "http inbound of SG for public"
}


# セキュリティグループルール(HTTPSのインバウンド)の定義
resource "aws_security_group_rule" "of_https_ingress_1" {
  type              = "ingress"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.for_web.id
  to_port           = 443
  cidr_blocks       = var.cidr_block_1
  description       = "https inbound of SG for public"
}


# セキュリティグループルール(HTTPSのインバウンド)の定義
resource "aws_security_group_rule" "of_https_ingress_2" {
  type              = "ingress"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.for_web.id
  to_port           = 443
  ipv6_cidr_blocks  = var.cidr_block_2
  description       = "https inbound of SG for public"
}


# インスタンスの定義
resource "aws_instance" "of_public" {
  ami                    = "ami-0af1df87db7b650f4"
  instance_type          = "t2.micro"
  key_name               = var.aws_key_name
  subnet_id              = aws_subnet.of_public_1a.id
  vpc_security_group_ids = [
    aws_security_group.for_web.id
  ]
  associate_public_ip_address = "true"
  root_block_device {
    volume_type          = "gp2"
    volume_size          = "8"
  }
  tags = {
    Name = var.instance_name
  }
}


# RDS専用のセキュリティグループ
resource "aws_security_group" "for_db" {
  name          = var.rds_sg_name
  vpc_id        = aws_vpc.of_terraform_on_docker.id
  description   = "Define of SG for rds"
  ingress {
    from_port   = 3306
    protocol    = "tcp"
    to_port     = 3306
    cidr_blocks = var.cidr_block_1
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = var.cidr_block_1
  }
  
  tags = {
    Name = var.rds_sg_name
  }
}


# RDSの定義
resource "aws_db_instance" "of_private" {
  availability_zone           = var.az_names["1a"]
  identifier                 = var.db_name
  engine                      = "MySQL"
  engine_version              = "5.7.22"
  instance_class              = "db.t2.micro"
  multi_az                    = false
  storage_type                = "gp2"
  allocated_storage           = 20
  username                    = var.db_user_name
  password                    = var.db_user_password
  max_allocated_storage       = 1000
  skip_final_snapshot         = true
  vpc_security_group_ids      = [
    aws_security_group.for_db.id
  ]
  publicly_accessible         = false
  port                        = 3306
  parameter_group_name        = "default.mysql5.7"
  backup_retention_period     = 7
  monitoring_interval         = 0
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  db_subnet_group_name        = aws_db_subnet_group.of_private.name

  lifecycle {
    ignore_changes = [password, availability_zone]
  }
}


# RDSサブネットグループ
resource "aws_db_subnet_group" "of_private" {
  name        = var.db_subnet_group_name
  description = "It is a DB subnet group on tf_vpc."
  subnet_ids  = [
    aws_subnet.of_private_1a.id,
    aws_subnet.of_private_1c.id
  ]
  tags = {
    Name = var.db_subnet_group_name
  }
}


# ALB専用のセキュリティグループの定義
resource "aws_security_group" "for_alb" {
  name          = var.alb_sg_name
  vpc_id        = aws_vpc.of_terraform_on_docker.id
  description   = "Define of SG for alb"
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = var.cidr_block_1
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = var.cidr_block_1
  }
  tags = {
    Name = var.alb_sg_name
  }
}


#ALBの定義
resource "aws_lb" "of_terraform_on_docker" {
  name               = var.alb_name
  load_balancer_type = "application"
  internal           = false
  security_groups = [
    aws_security_group.for_alb.id
  ]
  subnets = [
    aws_subnet.of_public_1a.id,
    aws_subnet.of_public_1c.id
  ]
}

resource "aws_lb_target_group" "of_terraforma_on_docker" {
  name     = var.alb_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.of_terraform_on_docker.id
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}
