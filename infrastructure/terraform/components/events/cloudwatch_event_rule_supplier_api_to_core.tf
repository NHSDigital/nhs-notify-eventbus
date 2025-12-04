resource "aws_cloudwatch_event_rule" "supplier_api_to_core" {
  name           = "${local.csi}-supplier-api-to-core"
  description    = "Event rule for inbound Supplier API events to forward to Core"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  event_pattern = jsonencode({
    "detail" : {
      subject: [
        {"prefix": "letter-origin/letter-rendering/"}
      ],
      "type" : [
        { prefix = "uk.nhs.notify.supplier-api.letter.accepted" },
        { prefix = "uk.nhs.notify.supplier-api.letter.cancelled" },
        { prefix = "uk.nhs.notify.supplier-api.letter.delivered" },
        { prefix = "uk.nhs.notify.supplier-api.letter.dispatched" },
        { prefix = "uk.nhs.notify.supplier-api.letter.enclosed" },
        { prefix = "uk.nhs.notify.supplier-api.letter.failed" },
        { prefix = "uk.nhs.notify.supplier-api.letter.forwarded" },
        { prefix = "uk.nhs.notify.supplier-api.letter.pending" },
        { prefix = "uk.nhs.notify.supplier-api.letter.printed" },
        { prefix = "uk.nhs.notify.supplier-api.letter.rejected" },
        { prefix = "uk.nhs.notify.supplier-api.letter.returned" }
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "supplier_api_queue" {
  count = var.event_target_arns["notify_core_sns_topic"] != null ? 1 : 0

  rule           = aws_cloudwatch_event_rule.supplier_api_to_core.name
  arn            = var.event_target_arns["notify_core_sns_topic"]
  target_id      = "notify-core-supplier-api-queue"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
  role_arn       = aws_iam_role.send_to_notify_core.0.arn
  input_path     = "$.detail"

  dead_letter_config {
    arn = module.notify_core_dlq.sqs_queue_arn
  }
}
