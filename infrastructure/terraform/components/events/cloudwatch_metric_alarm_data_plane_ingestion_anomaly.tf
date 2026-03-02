resource "aws_cloudwatch_metric_alarm" "data_plane_ingestion_anomaly" {
  count = var.enable_event_anomaly_detection ? 1 : 0

  alarm_name          = "${local.csi}-data-plane-ingestion-anomaly"
  alarm_description   = "ANOMALY: Detects anomalous patterns in events ingested to the data plane event bus"
  comparison_operator = "LessThanLowerOrGreaterThanUpperThreshold"
  evaluation_periods  = var.event_anomaly_evaluation_periods
  threshold_metric_id = "ad1"
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "m1"
    return_data = true

    metric {
      metric_name = "Ingestion"
      namespace   = "AWS/Events"
      period      = var.event_anomaly_period
      stat        = "Sum"

      dimensions = {
        EventBusName = aws_cloudwatch_event_bus.data_plane.name
      }
    }
  }

  metric_query {
    id          = "ad1"
    expression  = "ANOMALY_DETECTION_BAND(m1, ${var.event_anomaly_band_width})"
    label       = "Ingestion (expected)"
    return_data = true
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-data-plane-ingestion-anomaly"
    }
  )
}
