resource "aws_sns_topic_subscription" "ordens_geradas_subscription" {
    topic_arn = "${aws_sns_topic.ordens_geradas.arn}"
    protocol = "sqs"
    endpoint = "${aws_sqs_queue.ordens_geradas.arn}"
    raw_message_delivery = true
}