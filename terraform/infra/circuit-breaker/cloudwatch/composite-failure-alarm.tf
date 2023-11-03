resource "aws_cloudwatch_composite_alarm" "composite_failure_alarm" {
  alarm_description = "Monitors error percentage and error sum of lambda function ${var.target_function_name}"
  alarm_name        = "composite_failure_alarm"

  alarm_rule = "ALARM(${aws_cloudwatch_metric_alarm.failure_percentage_alarm.alarm_name}) AND ALARM(${aws_cloudwatch_metric_alarm.failure_sum_alarm.alarm_name})"
}

resource "aws_cloudwatch_metric_alarm" "failure_percentage_alarm" {
  alarm_name                = "failure_percentage_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  threshold                 = 10
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
      namespace   = "lambda-circuit-breaker-${var.target_function_name}"
      period      = 10
      stat        = "Sum"
    }
  }

  metric_query {
    id = "invocations"
    return_data = false

    metric {
      metric_name = "Invocations"
      namespace   = "lambda-circuit-breaker-${var.target_function_name}"
      period      = 10
      stat        = "Sum"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "failure_sum_alarm" {
  alarm_name                = "failure_sum_alarm"
  metric_name               = "Errors"
  namespace                 = "lambda-circuit-breaker-${var.target_function_name}"
  period                    = 10
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  threshold                 = 10
  alarm_description         = "This metric monitors failures lambda"
  statistic                 = "Sum"
  treat_missing_data         = "notBreaching"
}