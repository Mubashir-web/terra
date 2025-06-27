resource "aws_internet_gateway" "igw-terra" {
  vpc_id = aws_vpc.VPC-terra.id

  tags = {
    Name = "igw-tf"
  }
}