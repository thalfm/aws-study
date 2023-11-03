module "cloudwatch" {
  source = "./cloudwatch"
  target_function_name = var.target_function_name
}

module "bucket" {
  source = "./bucket"
}

module "lambda" {
  source = "./lambda"
  target_function_name = var.target_function_name
  target_queue_name = var.target_queue_name
  target_queue_arn = var.target_queue_arn
  aws_lambda_bucket_name = module.bucket.aws_lambda_bucket_name
  region = var.region
  account_id = var.account_id
}
