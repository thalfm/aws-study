data "archive_file" "lambda_update_event_source" {
  type = "zip"

  source_dir  = path.module
  output_path = "${path.module}.zip"
}

resource "aws_s3_object" "lambda_update_event_source" {
  bucket = var.aws_lambda_bucket_name

  key    = "update-event-source.zip"
  source = data.archive_file.lambda_update_event_source.output_path

  etag = filemd5(data.archive_file.lambda_update_event_source.output_path)
}

resource "aws_lambda_function" "update_event_source" {
  function_name = "updateEventSource"

  s3_bucket = aws_s3_object.lambda_update_event_source.bucket
  s3_key    = aws_s3_object.lambda_update_event_source.key

  runtime = "nodejs18.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_update_event_source.output_base64sha256

  role = aws_iam_role.lambda_update_event_source.arn

  environment {
    variables = {
      QUEUE_ARN     = var.target_queue_arn
      FUNCTION_NAME = var.target_function_name
    }
  }
}

resource "aws_cloudwatch_event_rule" "open_circuit_rule" {
  name        = "open_circuit_rule"
  description = "CloudWatch Alarm State Change"

  event_pattern = jsonencode({
    source = [
      "aws.cloudwatch"
    ]
    detail-type = [
      "CloudWatch Alarm State Change"
    ]
    detail = {
      state = {
        value = [
          "ALARM"
        ]
      }
      "alarmName": [
        var.cloudwatch_composite_failure_alarm_name
      ]
    }

    resources = [
      var.cloudwatch_composite_failure_alarm_arn
    ]
  })
}

resource "aws_cloudwatch_event_target" "open_circuit_rule_target" {
  rule      = aws_cloudwatch_event_rule.open_circuit_rule.name
  target_id = "InvokeOpenCircuit"
  arn       = aws_lambda_function.update_event_source.arn
  input     = jsonencode({ enabled = false })
}

resource "aws_cloudwatch_log_group" "update_event_source" {
  name = "/aws/lambda/${aws_lambda_function.update_event_source.function_name}"

  retention_in_days = 30
}


resource "aws_iam_role" "lambda_update_event_source" {
  name = "serverless_lambda_update_event_source"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name   = "policy-update-event-source"
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Action   = "lambda:listEventSourceMappings"
          Effect   = "Allow"
          Sid      = "ListEventSourceMappings"
          Resource = "*"
        },
        {
          Action   = "lambda:UpdateEventSourceMapping"
          Effect   = "Allow"
          Sid      = "UpdateEventSourceMappingOfTargetFunction"
          Resource = "arn:aws:lambda:${var.region}:${var.account_id}:event-source-mapping:*"
        }
      ]
    })
  }
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_event_source.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.open_circuit_rule.arn
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_update_event_source.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
