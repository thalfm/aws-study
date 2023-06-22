resource "aws_iam_policy" "ordens_geradas" {
  name = "${var.environment}-ordens-geradas"

  policy = templatefile("${path.module}/templates/lambda-sqs-policy.tpl", {
    action = join("\",\"", ["sqs:ReceiveMessage",
      "sqs:DeleteMessage",
    "sqs:GetQueueAttributes"]),
    resource = "${aws_sqs_queue.ordens_geradas.arn}",
  })
}