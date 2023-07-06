resource "aws_ecr_repository" "ecr_erp" {
    name = "ecr-erp"
    tags = {
        Name = "ecr-erp"
    }
}

output "repository_url" {
  value = aws_ecr_repository.ecr_erp.repository_url
}