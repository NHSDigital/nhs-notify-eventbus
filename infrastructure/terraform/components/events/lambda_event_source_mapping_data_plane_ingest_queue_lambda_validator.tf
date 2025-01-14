resource "aws_lambda_event_source_mapping" "data_plane_ingest_queue_lambda_validator" {
  event_source_arn        = module.sqs_queue_data_plane_ingest.sqs_queue_arn
  function_name           = module.lambda_data_plane_validator.function_name
  function_response_types = ["ReportBatchItemFailures"]
}
