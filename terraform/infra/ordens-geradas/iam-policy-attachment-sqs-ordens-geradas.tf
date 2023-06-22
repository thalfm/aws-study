resource "aws_iam_policy_attachment" "ordens_geradas_policy_attachment" {
  name       = "${var.environment}-ordens-geradas-attachment"
  roles      = ["${aws_iam_role.ordens_geradas.name}"]
  policy_arn = "${aws_iam_policy.ordens_geradas.arn}"
}