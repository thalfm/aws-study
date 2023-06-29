data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
    count = 2
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.${count.index}.0/24"
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    map_public_ip_on_launch = true

    tags = {
        "Name" = "subnet_public"
    }
}

resource "aws_subnet" "private" {
    count = 2
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.${count.index + 10}.0/24"
    availability_zone = element(data.aws_availability_zones.available.names, count.index)

    tags = {
        "Name" = "subnet_private"
    }
}