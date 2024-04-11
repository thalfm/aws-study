output "lambda_trial_message_poller_arn" {
  value = module.trial-message-poller.lambda_trial_message_poller_arn
}

output "lambda_update_event_source_arn" {
  value = module.update-event-source.lambda_update_event_source_arn
}

output "lambda_update_event_source_name" {
  value = module.update-event-source.lambda_update_event_source_name
}