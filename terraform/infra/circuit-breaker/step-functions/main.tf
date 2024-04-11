resource "aws_iam_role" "step_functions_role" {
  name = "step_functions_role_poc_sf"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = ["states.amazonaws.com", "events.amazonaws.com"]
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "lambda_access_policy" {
  statement {
    actions = [
      "lambda:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "state-execution" {
  name = "StepFunctionStateExecution"
  role = aws_iam_role.step_functions_role.id

  policy = jsonencode({
    "Version"   = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Action" = [
          "states:StartExecution"
        ],
        "Resource" = [
          aws_sfn_state_machine.half_open_step_function.arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "step_functions_policy_lambda" {
  name   = "step_functions_policy_lambda_policy_half_open"
  policy = data.aws_iam_policy_document.lambda_access_policy.json
}

resource "aws_iam_role_policy_attachment" "step_functions_to_lambda" {
  role       = aws_iam_role.step_functions_role.name
  policy_arn = aws_iam_policy.step_functions_policy_lambda.arn
}

# Step Functions State Machine
resource "aws_sfn_state_machine" "half_open_step_function" {
  name     = "HalfOpenSF"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = <<EOF
{
   "Comment":"Manages the half open state.",
   "StartAt":"Wait",
   "States":{
      "Wait":{
         "Type":"Wait",
         "Seconds":15,
         "Next":"Trial"
      },
      "Trial":{
         "Type":"Task",
         "Resource":"${var.lambda_sqs_trial_poller_arn}",
         "ResultPath":"$.trialResult",
         "Catch":[
            {
               "ErrorEquals":[
                  "States.ALL"
               ],
               "Next":"Choice"
            }
         ],
         "Next":"Choice"
      },
      "Choice":{
         "Type":"Choice",
         "Choices":[
            {
               "Variable":"$.trialResult",
               "StringEquals":"passed",
               "Next":"Close"
            },
            {
               "Variable":"$.trialResult",
               "StringEquals":"failed",
               "Next":"Wait"
            },
            {
               "Variable":"$.trialResult",
               "StringEquals":"no-message-available",
               "Next":"Wait"
            }
         ],
         "Default":"Close"
      },
      "Close":{
         "Type":"Task",
         "Resource":"${var.lambda_update_event_source_arn}",
         "Parameters":{
            "enabled":true
         },
         "End":true
      }
   }
}
EOF
}

resource "aws_cloudwatch_event_rule" "half_open_circuit_rule" {
  name        = "half_open_circuit_rule"
  description = "CloudWatch Alarm State Change"

  event_pattern = jsonencode({
    source = [
      "aws.cloudwatch"
    ]
    detail-type = [
      "CloudWatch Alarm State Change"
    ]
    detail = {
      previousState = {
        value = [
          "ALARM"
        ]
      }
      "alarmName" : [
        var.cloudwatch_composite_failure_alarm_name
      ]
    }

    resources = [
      var.cloudwatch_composite_failure_alarm_arn
    ]
  })
}

resource "aws_cloudwatch_event_target" "half_open_circuit_rule_target" {
  rule      = aws_cloudwatch_event_rule.half_open_circuit_rule.name
  target_id = "InvokeOpenCircuit"
  role_arn  = aws_iam_role.step_functions_role.arn
  arn       = aws_sfn_state_machine.half_open_step_function.arn
}

