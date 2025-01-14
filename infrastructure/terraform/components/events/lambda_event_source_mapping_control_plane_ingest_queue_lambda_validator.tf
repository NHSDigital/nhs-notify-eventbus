resource "aws_lambda_event_source_mapping" "control_plane_ingest_queue_lambda_validator" {
  event_source_arn        = module.sqs_queue_control_plane_ingest.sqs_queue_arn
  function_name           = module.lambda_control_plane_validator.function_name
  function_response_types = ["ReportBatchItemFailures"]
}
