resource "aws_cloudwatch_log_metric_filter" "errors_metric_filter" {
  name           = "ErrorssMetricFilter"
  pattern        = "ERROR"
  log_group_name = "/aws/lambda/${var.target_function_name}"

  metric_transformation {
    name      = "Errors"
    namespace = "lambda-circuit-breaker-consumidor-processamento"
    value     = "1"
  }
}