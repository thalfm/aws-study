output "lambda_update_event_source_arn" {
  value = aws_lambda_function.update_event_source.arn
}

output "lambda_update_event_source_name" {
  value = aws_lambda_function.update_event_source.function_name
}
