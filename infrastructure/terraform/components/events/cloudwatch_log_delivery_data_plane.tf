resource "aws_cloudwatch_log_delivery_destination" "data_plane" {
  name = "EventsDeliveryDestination-${aws_cloudwatch_event_bus.data_plane.name}"

  delivery_destination_configuration {
    destination_resource_arn = aws_cloudwatch_log_group.data_plane.arn
  }
}

resource "aws_cloudwatch_log_delivery" "data_plane_info_logs" {
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.data_plane.arn
  delivery_source_name     = aws_cloudwatch_log_delivery_source.data_plane_info_logs.name
}

resource "aws_cloudwatch_log_delivery" "data_plane_error_logs" {
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.data_plane.arn
  delivery_source_name     = aws_cloudwatch_log_delivery_source.data_plane_error_logs.name
  depends_on = [
    aws_cloudwatch_log_delivery.data_plane_info_logs
  ]
}

resource "aws_cloudwatch_log_delivery" "data_plane_trace_logs" {
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.data_plane.arn
  delivery_source_name     = aws_cloudwatch_log_delivery_source.data_plane_trace_logs.name
  depends_on = [
    aws_cloudwatch_log_delivery.data_plane_error_logs
  ]
}
