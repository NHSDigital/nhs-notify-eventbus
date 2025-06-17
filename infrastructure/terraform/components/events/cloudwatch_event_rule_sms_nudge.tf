resource "aws_cloudwatch_event_rule" "sms_nudge" {
  name           = "${local.csi}-sms-nudge"
  description    = "SMS Nudge event rule for inbound events"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  event_pattern = jsonencode({
    "detail": {
      "type": [
        "uk.nhs.notify.channels.nhsapp.SupplierStatusChange.v1"
      ],
      "dataschemaversion": [{
        "prefix": "1."
      }],
      "data": {
        "supplierStatus": [
          "unnotified"
        ]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "sms_nudge" {
  rule           = aws_cloudwatch_event_rule.sms_nudge.name
  arn            = var.event_target_arns["sms_nudge"]
  target_id      = "unnotified-events-target"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
}
