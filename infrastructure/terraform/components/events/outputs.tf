output "event_buses" {
  value = {
    control_plane = {
      name = aws_cloudwatch_event_bus.control_plane.name
      arn  = aws_cloudwatch_event_bus.control_plane.arn
    }
    data_plane = {
      name = aws_cloudwatch_event_bus.data_plane.name
      arn  = aws_cloudwatch_event_bus.data_plane.arn
    }
  }
}
