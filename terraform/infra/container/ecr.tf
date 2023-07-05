resource "aws_ecr_repository" "ecr-erp" {
    name = "ecr-erp"
    tags = {
        Name = "ecr-erp"
    }
}