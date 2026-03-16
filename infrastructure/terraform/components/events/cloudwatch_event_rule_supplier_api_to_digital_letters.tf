resource "aws_cloudwatch_event_rule" "supplier_api_to_digital_letters" {
  name           = "${local.csi}-supplier-api-to-digital-letters"
  description    = "Supplier API events routed to Digital Letters"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        { "prefix" : "uk.nhs.notify.supplier-api.letter." },
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "supplier_api_to_digital_letters" {
  count = var.event_target_arns["digital_letters_eventbus"] != null ? 1 : 0

  rule           = aws_cloudwatch_event_rule.supplier_api_to_digital_letters.name
  arn            = var.event_target_arns["digital_letters_eventbus"]
  target_id      = "supplier-api-to-digital-letters-eventbus"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
}
