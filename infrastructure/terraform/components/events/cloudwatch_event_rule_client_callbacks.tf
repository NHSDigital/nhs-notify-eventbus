resource "aws_cloudwatch_event_rule" "client_callbacks" {
  name           = "${local.csi}-client-callbacks"
  description    = "Client Callbacks event rule for inbound events"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        { "wildcard" : "uk.nhs.notify.client-callbacks.*" },
      ],
      "dataschemaversion" : [{
        "prefix" : "1."
      }]
    }
  })
}

resource "aws_cloudwatch_event_target" "client_callbacks" {
  rule           = aws_cloudwatch_event_rule.client_callbacks.name
  arn            = var.event_target_arns["client_callbacks"]
  target_id      = "callbacks-events-target"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
}
