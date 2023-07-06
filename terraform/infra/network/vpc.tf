resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "vpc_lab"
    }
}

output "vpc_id" {
  value = aws_vpc.main.id
}