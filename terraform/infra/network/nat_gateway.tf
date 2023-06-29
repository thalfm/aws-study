resource "aws_eip" "nat_gateway_eip" {
  count = 2
}

resource "aws_nat_gateway" "nat_gateway" {
  count = 2
  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id = aws_subnet.public[count.index].id   
}