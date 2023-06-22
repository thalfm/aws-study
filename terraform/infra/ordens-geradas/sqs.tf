resource "aws_sqs_queue" "ordens_geradas" {
  name           = "${var.environment}-ordens-geradas"
  redrive_policy = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.ordens_geradas_dead.arn}\",\"maxReceiveCount\":3}"
  policy = templatefile("${path.module}/templates/sqs-sns-policy.tpl",
    {
      resource   = "arn:aws:sqs:${var.region}:${var.account_id}:${var.environment}-ordens-geradas"
      source_arn = "${aws_sns_topic.ordens_geradas.arn}"
  })
}


resource "aws_sqs_queue" "ordens_geradas_dead" {
  name = "${var.environment}-ordens-geradas-dead"
}
