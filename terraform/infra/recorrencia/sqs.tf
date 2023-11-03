resource "aws_sqs_queue" "recorrencia" {
  name           = "${var.environment}-recorrencia"
}

output "aws_sqs_queue_recorrencia_name" {
  value = "${aws_sqs_queue.recorrencia.name}"
}

output "aws_sqs_queue_recorrencia_arn" {
  value = "${aws_sqs_queue.recorrencia.arn}"
}