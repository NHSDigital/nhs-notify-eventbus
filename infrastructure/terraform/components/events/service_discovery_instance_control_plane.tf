resource "aws_service_discovery_instance" "control_plane" {
  service_id   = aws_service_discovery_service.main.id
  instance_id  = "control-plane-queue"

  attributes = {
    arn         = module.sqs_queue_control_plane_ingest.sqs_queue_arn
    queue_url   = module.sqs_queue_control_plane_ingest.sqs_queue_url
    description = "SQS queue in Cloud Map"
    kms_key_arn = module.kms.key_arn
    kms_key_id  = module.kms.key_id
  }
}
