resource "aws_cloudwatch_event_rule" "app_response" {
  name           = "${local.csi}-app-response"
  description    = "App Response event rule for inbound events"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  ## The below is a dummy pattern. Schema to be defined.
  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        { "wildcard" : "uk.nhs.notify.app-response.*" },
      ],
      "dataschemaversion" : [{
        "prefix" : "1."
      }]
    }
  })
}

resource "aws_cloudwatch_event_target" "app_response" {
  rule           = aws_cloudwatch_event_rule.app_response.name
  arn            = var.event_target_arns["app_response"]
  target_id      = "app-response-events-target"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
}
