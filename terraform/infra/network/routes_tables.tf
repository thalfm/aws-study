resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        "Name" = "public_route_table"
    }
}

resource "aws_route_table_association" "public_subnet_association" {
   count = 2
   subnet_id = aws_subnet.public[count.index].id
   route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
    count = 2
    vpc_id = aws_vpc.main.id
    # route {
    #     cidr_block = "0.0.0.0/0"
    #     nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
    # }

    tags = {
        "Name" = "private_route_table"
    }
}

resource "aws_route_table_association" "private_subnet_association" {
   count = 2
   subnet_id = aws_subnet.private[count.index].id
   route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_route" "private_internet_access_route" {
  count = 2
  route_table_id = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id

}
