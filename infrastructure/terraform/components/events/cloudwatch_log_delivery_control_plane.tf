resource "aws_cloudwatch_log_delivery_destination" "control_plane" {
  name = "EventsDeliveryDestination-${aws_cloudwatch_event_bus.control_plane.name}"

  delivery_destination_configuration {
    destination_resource_arn = aws_cloudwatch_log_group.control_plane.arn
  }
}

resource "aws_cloudwatch_log_delivery" "control_plane_info_logs" {
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.control_plane.arn
  delivery_source_name     = aws_cloudwatch_log_delivery_source.control_plane_info_logs.name
}

resource "aws_cloudwatch_log_delivery" "control_plane_error_logs" {
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.control_plane.arn
  delivery_source_name     = aws_cloudwatch_log_delivery_source.control_plane_error_logs.name
  depends_on = [
    aws_cloudwatch_log_delivery.control_plane_info_logs
  ]
}

resource "aws_cloudwatch_log_delivery" "control_plane_trace_logs" {
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.control_plane.arn
  delivery_source_name     = aws_cloudwatch_log_delivery_source.control_plane_trace_logs.name
  depends_on = [
    aws_cloudwatch_log_delivery.control_plane_error_logs
  ]
}
