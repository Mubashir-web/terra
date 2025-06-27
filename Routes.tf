resource "aws_route_table_association" "Routes-terra" {
  subnet_id      = aws_subnet.Sub-terra.id
  route_table_id = aws_route_table.RT-terra.id
}