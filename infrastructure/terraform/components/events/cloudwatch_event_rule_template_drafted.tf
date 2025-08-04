resource "aws_cloudwatch_event_rule" "template_drafted" {
  name           = "${local.csi}-template-drafted"
  description    = "Event rule for inbound TemplateDrafted events"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name

  event_pattern = jsonencode({
    "detail": {
      "type": [
        "uk.nhs.notify.template-management.TemplateDrafted.v1"
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "template_drafted_notify_core_templates_queue" {
  rule           = aws_cloudwatch_event_rule.template_drafted.name
  arn            = var.event_target_arns["notify_core_templates_queue"]
  target_id      = "notify-core-templates-queue"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name
  role_arn       = aws_iam_role.send_to_notify_core_templates_queue.arn
}
