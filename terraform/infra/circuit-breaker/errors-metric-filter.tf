resource "aws_cloudwatch_log_metric_filter" "errors_metric_filter" {
  name           = "ErrorssMetricFilter"
  pattern        = '?"Task timed out" ?"ERROR Invoke Error" ?"[ERROR]"'
  log_group_name = "/aws/lambda/consumidor-processamento"

  metric_transformation {
    name      = "Errors"
    namespace = "lambda-circuit-breaker-consumidor-processamento"
    value     = "1"
  }
}