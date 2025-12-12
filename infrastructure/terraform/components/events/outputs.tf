output "control_plane_event_bus" {
  value = {
    name = aws_cloudwatch_event_bus.control_plane.name
    arn  = aws_cloudwatch_event_bus.control_plane.arn
  }
}

output "data_plane_event_bus" {
  value = {
    name = aws_cloudwatch_event_bus.data_plane.name
    arn  = aws_cloudwatch_event_bus.data_plane.arn
  }
}
