resource "aws_cloudwatch_composite_alarm" "composite_failure_alarm" {
  alarm_description = "Monitors error percentage and error sum of lambda function consumidor-processamento"
  alarm_name        = "example-composite-alarm"

  alarm_rule = <<EOF
ALARM(${aws_cloudwatch_metric_alarm.failure_percentage_alarm.failure_percentage_alarm}) AND
ALARM(${aws_cloudwatch_metric_alarm.failure_sum_alarm.failure_sum_alarm})
EOF
}

resource "aws_cloudwatch_metric_alarm" "failure_percentage_alarm" {
  alarm_name                = "failure_percentage_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  threshold                 = 50
  alarm_description         = "This metric monitors failures lambda"

  metric_query {
    id          = "errorsPercentage"
    return_data = true
    expression  = "100 * errors / invocations"
  }

  metric_query {
    id          = "errors"
    return_data = false
    metric {
      metric_name = "Errors"
      namespace   = "lambda-circuit-breaker-consumidor-processamento"
      period      = 10
      stat        = "Sum"
    }
  }

  metric_query {
    id = "invocations"
    return_data = false

    metric {
      metric_name = "Invocations"
      namespace   = "lambda-circuit-breaker-consumidor-processamento"
      period      = 10
      stat        = "Sum"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "failure_sum_alarm" {
  alarm_name                = "failure_sum_alarm"
  metric_name               = "Errors"
  namespace                 = "lambda-circuit-breaker-consumidor-processamento"
  period                    = 10
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  threshold                 = 50
  alarm_description         = "This metric monitors failures lambda"
  statistic                 = "Sum"
  treat_missing_data         = "notBreaching"
}