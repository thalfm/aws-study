data "archive_file" "lambda_trial_message_poller" {
  type = "zip"

  source_dir  = path.module
  output_path = "${path.module}.zip"
}

resource "aws_s3_object" "lambda_trial_message_poller" {
  bucket = var.aws_lambda_bucket_name

  key    = "trial-message-poller.zip"
  source = data.archive_file.lambda_trial_message_poller.output_path

  etag = filemd5(data.archive_file.lambda_trial_message_poller.output_path)
}

resource "aws_lambda_function" "trial_message_poller" {
  function_name = "TrialMessagePoller"

  s3_bucket = aws_s3_object.lambda_trial_message_poller.bucket
  s3_key    = aws_s3_object.lambda_trial_message_poller.key

  runtime = "nodejs18.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.lambda_trial_message_poller.output_base64sha256

  role = aws_iam_role.lambda_trial_message_poller.arn

  environment {
    variables = {
      QUEUE_NAME    = var.target_queue_name
      FUNCTION_NAME = var.target_function_name
    }
  }
}

resource "aws_cloudwatch_log_group" "trial_message_poller" {
  name = "/aws/lambda/${aws_lambda_function.trial_message_poller.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_trial_message_poller" {
  name = "serverless_lambda_trial_message_poller"

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
}

resource "aws_iam_role_policy" "queue_target_receive_message" {
  name = "LambdaQueueTargetReceiveMessage"
  role = aws_iam_role.lambda_trial_message_poller.id

  policy = jsonencode({
    "Version"   = "2012-10-17",
    "Statement" = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ],
        Effect   = "Allow",
        Resource = var.target_queue_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_invoke_target_lambda" {
  name = "LambdaInvokeTargetLambda"
  role = aws_iam_role.lambda_trial_message_poller.id

  policy = jsonencode({
    "Version"   = "2012-10-17",
    "Statement" = [
      {
        Action = [
          "lambda:InvokeFunction"
        ],
        Effect   = "Allow",
        Resource = var.target_function_arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_trial_message_poller.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
