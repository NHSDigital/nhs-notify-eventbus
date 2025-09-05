resource "aws_cloudwatch_event_bus" "data_plane" {
  name = "${local.csi}-data-plane"

  kms_key_identifier = module.kms.key_arn

  log_config {
    include_detail = "FULL"
    level          = "TRACE"
  }
}

# CloudWatch Log Delivery Sources for INFO, ERROR, and TRACE logs
resource "aws_cloudwatch_log_delivery_source" "data_plane_info_logs" {
  name         = "EventBusSource-${aws_cloudwatch_event_bus.data_plane.name}-INFO_LOGS"
  log_type     = "INFO_LOGS"
  resource_arn = aws_cloudwatch_event_bus.data_plane.arn
}

resource "aws_cloudwatch_log_delivery_source" "data_plane_error_logs" {
  name         = "EventBusSource-${aws_cloudwatch_event_bus.data_plane.name}-ERROR_LOGS"
  log_type     = "ERROR_LOGS"
  resource_arn = aws_cloudwatch_event_bus.data_plane.arn
}

resource "aws_cloudwatch_log_delivery_source" "data_plane_trace_logs" {
  name         = "EventBusSource-${aws_cloudwatch_event_bus.data_plane.name}-TRACE_LOGS"
  log_type     = "TRACE_LOGS"
  resource_arn = aws_cloudwatch_event_bus.data_plane.arn
}
