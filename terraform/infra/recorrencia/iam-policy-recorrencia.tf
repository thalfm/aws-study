resource "aws_iam_policy" "recorrencia" {
  name = "${var.environment}-recorrencia"

  policy = templatefile("${path.module}/templates/lambda-sqs-policy.tpl", {
    action = join("\",\"", ["sqs:ReceiveMessage",
      "sqs:DeleteMessage",
    "sqs:GetQueueAttributes"]),
    resource = "${aws_sqs_queue.recorrencia.arn}",
  })
}