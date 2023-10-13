resource "aws_iam_role" "recorrencia" {
  name = "${var.environment}-recorrencia"

  assume_role_policy = templatefile("${path.module}/templates/lambda-base-policy.tpl", {})
}

output "recorrencia_role_arn" {
    value = "${aws_iam_role.recorrencia.arn}"
}