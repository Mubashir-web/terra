terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.region_name
}
resource "aws_vpc" "VPC-terra" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.vpc_tag
  }
}
resource "aws_subnet" "Sub-terra" {
  vpc_id            = aws_vpc.VPC-terra.id
  cidr_block        = var.subnetcidr
  availability_zone = var.az

  tags = {
    Name = "Sub-1"
  }
}
resource "aws_security_group" "SG-terra" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.VPC-terra.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_SG"
  }
}
resource "aws_internet_gateway" "igw-terra" {
  vpc_id = aws_vpc.VPC-terra.id

  tags = {
    Name = "igw-tf"
  }
}
resource "aws_route_table" "RT-terra" {
  vpc_id = aws_vpc.VPC-terra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-terra.id
  }

  tags = {
    Name = "RT"
  }
}
resource "aws_route_table_association" "Routes-terra" {
  subnet_id      = aws_subnet.Sub-terra.id
  route_table_id = aws_route_table.RT-terra.id
}
resource "aws_s3_bucket" "s3-bucket01" {
  bucket = "mucci-terra01"

  tags = {
    Name        = "mucci-terra01"
    Environment = "Dev"
  }
  depends_on = [aws_route_table_association.Routes-terra]

}

resource "aws_s3_bucket" "s3-bucket02" {
  bucket = var.bucket02

  tags = {
    Name        = "mucci-terr2"
    Environment = "Dev"
  }
  lifecycle {
    create_before_destroy = true
    #prevent_destroy       = true
    ignore_changes        = [
      tags["LastModifiedBy"]
    ]
  }
  depends_on = [aws_s3_bucket.s3-bucket03]
}

resource "aws_s3_bucket" "s3-bucket03" {
  bucket = "mucci-terra03"

  tags = {
    Name        = "mucci-terra03"
    Environment = "Dev"
  }
  depends_on = [aws_s3_bucket.s3-bucket01]
}