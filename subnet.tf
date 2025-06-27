resource "aws_subnet" "Sub-terra" {
  vpc_id     = aws_vpc.VPC-terra.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Sub-1"
  }
}