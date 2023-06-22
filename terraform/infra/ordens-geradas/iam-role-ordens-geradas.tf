resource "aws_iam_role" "ordens_geradas" {
  name = "${var.environment}-ordens-geradas"

  assume_role_policy = templatefile("${path.module}/templates/lambda-base-policy.tpl", {})
}

output "ordens_geradas_role_arn" {
    value = "${aws_iam_role.ordens_geradas.arn}"
}