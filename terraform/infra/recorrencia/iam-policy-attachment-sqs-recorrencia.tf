resource "aws_iam_policy_attachment" "recorrencia_policy_attachment" {
  name       = "${var.environment}-recorrencia-attachment"
  roles      = ["${aws_iam_role.recorrencia.name}"]
  policy_arn = "${aws_iam_policy.recorrencia.arn}"
}