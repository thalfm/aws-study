resource "aws_cloudwatch_log_metric_filter" "invocations_metric_filter" {
  name           = "InvocationsMetricFilter"
  pattern        = "END RequestId"
  log_group_name = "/aws/lambda/consumidor-processamento"

  metric_transformation {
    name      = "Invocations"
    namespace = "lambda-circuit-breaker-consumidor-processamento"
    value     = "1"
  }
}