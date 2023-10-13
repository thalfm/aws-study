resource "aws_sqs_queue" "recorrencia" {
  name           = "${var.environment}-recorrencia"
}
