resource "aws_cloudwatch_event_rule" "template_events" {
  name           = "${local.csi}-template-drafted"
  description    = "Event rule for template-management to core events"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : "${jsonencode(var.template_management_event_types)}",
      "source" : [{
        "wildcard" : "//notify.nhs.uk/app/*/${var.template_management_source_environment}",
      }]
    }
  })
}

resource "aws_cloudwatch_event_target" "template_management_to_core_templates_queue" {
  count = var.event_target_arns["notify_core_templates_queue"] != null ? 1 : 0

  rule           = aws_cloudwatch_event_rule.template_events.name
  arn            = var.event_target_arns["notify_core_templates_queue"]
  target_id      = "notify-core-templates-queue"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name
  role_arn       = aws_iam_role.send_to_notify_core_templates_queue.0.arn
  input_path     = "$.detail"

  dead_letter_config {
    arn = module.templates_dlq.sqs_queue_arn
  }
}
