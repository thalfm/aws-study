module "trial-message-poller" {
  source = "./trial-message-poller"
  target_function_name = var.target_function_name
  target_queue_name = var.target_queue_name
  aws_lambda_bucket_name = var.aws_lambda_bucket_name
}

module "update-event-source" {
  source = "./update-event-source"
  target_function_name = var.target_function_name
  target_queue_arn = var.target_queue_arn
  aws_lambda_bucket_name = var.aws_lambda_bucket_name
  region = var.region
  account_id = var.account_id
}