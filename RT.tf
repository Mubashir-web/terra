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