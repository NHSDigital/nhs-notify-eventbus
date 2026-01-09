resource "aws_cloudwatch_event_rule" "app_response_request" {
  name           = "${local.csi}-app-response-request"
  description    = "App Response event rule for inbound request events"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  ## The below is a dummy pattern. Schema to be defined.
  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        "uk.nhs.notify.app-response.*"
      ],
      "dataschemaversion" : [{
        "prefix" : "1."
      }]
    }
  })
}

resource "aws_cloudwatch_event_target" "app_response_request" {
  rule           = aws_cloudwatch_event_rule.app_response_request.name
  arn            = var.event_target_arns["app_response_request"]
  target_id      = "app-response-request-events-target"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
}
