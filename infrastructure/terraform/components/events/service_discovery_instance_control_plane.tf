resource "aws_service_discovery_instance" "control_plane" {
  service_id   = aws_service_discovery_service.main.id
  instance_id  = "control-plane-event-bus"

  attributes = {
    arn         = aws_cloudwatch_event_bus.control_plane.arn
    description = "EventBus Cloud Map"
    kms_key_arn = module.kms.key_arn
    kms_key_id  = module.kms.key_id
  }
}
