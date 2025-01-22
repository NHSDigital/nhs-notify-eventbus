resource "aws_service_discovery_instance" "data_plane" {
  service_id   = aws_service_discovery_service.main.id
  instance_id  = "data-plane-event-bus"

  attributes = {
    arn         = aws_cloudwatch_event_bus.data_plane.arn
    description = "EventBus in Cloud Map"
    kms_key_arn = module.kms.key_arn
    kms_key_id  = module.kms.key_id
  }
}
