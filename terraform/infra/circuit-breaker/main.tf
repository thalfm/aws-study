module "cloudwatch" {
  source = "./cloudwatch"
  target_function_name = var.target_function_name
}

module "bucket" {
  source = "./bucket"
}

module "lambda" {
  source = "./lambda"
  cloudwatch_composite_failure_alarm_arn = module.cloudwatch.cloudwatch_composite_failure_alarm_arn
  cloudwatch_composite_failure_alarm_name = module.cloudwatch.cloudwatch_composite_failure_alarm_name
  target_function_name = var.target_function_name
  target_function_arn = var.target_function_arn
  target_queue_name = var.target_queue_name
  target_queue_arn = var.target_queue_arn
  aws_lambda_bucket_name = module.bucket.aws_lambda_bucket_name
  region = var.region
  account_id = var.account_id
}


module "step_functions" {
  source = "./step-functions"
  lambda_sqs_trial_poller_arn = module.lambda.lambda_trial_message_poller_arn
  lambda_update_event_source_arn =  module.lambda.lambda_update_event_source_arn
  lambda_update_event_source_name =  module.lambda.lambda_update_event_source_name
  cloudwatch_composite_failure_alarm_arn = module.cloudwatch.cloudwatch_composite_failure_alarm_arn
  cloudwatch_composite_failure_alarm_name = module.cloudwatch.cloudwatch_composite_failure_alarm_name
}
