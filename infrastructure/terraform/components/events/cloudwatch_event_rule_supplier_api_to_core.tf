resource "aws_cloudwatch_event_rule" "supplier_api_to_core" {
  name           = "${local.csi}-supplier-api-to-core"
  description    = "Event rule for inbound Supplier API events to forward to Core"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  event_pattern = jsonencode({
    "detail" : {
      subject : [
        { "prefix" : "letter-origin/letter-rendering/" }
      ],
      "type" : [
        { prefix = "uk.nhs.notify.supplier-api.letter.ACCEPTED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.CANCELLED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.DELIVERED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.DISPATCHED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.ENCLOSED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.FAILED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.FORWARDED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.PENDING" },
        { prefix = "uk.nhs.notify.supplier-api.letter.PRINTED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.REJECTED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.RETURNED" }
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
