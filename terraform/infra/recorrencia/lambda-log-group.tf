resource "aws_cloudwatch_log_group" "recorrencia" {
  name = "/aws/lambda/consumidor-processamento"
  retention_in_days = 30
}