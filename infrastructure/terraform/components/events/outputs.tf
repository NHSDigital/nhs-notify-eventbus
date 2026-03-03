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

output "data_plane_ingestion_anomaly_alarm" {
  description = "Data plane ingestion anomaly detection alarm details"
  value = var.enable_event_anomaly_detection ? {
    arn  = aws_cloudwatch_metric_alarm.data_plane_ingestion_anomaly[0].arn
    name = aws_cloudwatch_metric_alarm.data_plane_ingestion_anomaly[0].alarm_name
  } : null
}

output "data_plane_invocations_anomaly_alarm" {
  description = "Data plane invocations anomaly detection alarm details"
  value = var.enable_event_anomaly_detection ? {
    arn  = aws_cloudwatch_metric_alarm.data_plane_invocations_anomaly[0].arn
    name = aws_cloudwatch_metric_alarm.data_plane_invocations_anomaly[0].alarm_name
  } : null
}

output "control_plane_ingestion_anomaly_alarm" {
  description = "Control plane ingestion anomaly detection alarm details"
  value = var.enable_event_anomaly_detection ? {
    arn  = aws_cloudwatch_metric_alarm.control_plane_ingestion_anomaly[0].arn
    name = aws_cloudwatch_metric_alarm.control_plane_ingestion_anomaly[0].alarm_name
  } : null
}

output "control_plane_invocations_anomaly_alarm" {
  description = "Control plane invocations anomaly detection alarm details"
  value = var.enable_event_anomaly_detection ? {
    arn  = aws_cloudwatch_metric_alarm.control_plane_invocations_anomaly[0].arn
    name = aws_cloudwatch_metric_alarm.control_plane_invocations_anomaly[0].alarm_name
  } : null
}
