resource "aws_cloudwatch_log_group" "control_plane" {
  name              = "/aws/vendedlogs/events/event-bus/${aws_cloudwatch_event_bus.control_plane.name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = module.kms.key_arn
}
