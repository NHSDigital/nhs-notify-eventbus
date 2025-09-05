resource "aws_cloudwatch_event_rule" "template_events" {
  name           = "${local.csi}-template-events"
  description    = "Event rule for inbound TemplateCompleted, TemplateDeleted and TemplateDrafted events"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        { "wildcard" : "uk.nhs.notify.template-management.TemplateCompleted.*" },
        { "wildcard" : "uk.nhs.notify.template-management.TemplateDrafted.*" },
        { "wildcard" : "uk.nhs.notify.template-management.TemplateDeleted.*" }
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "templates_queue" {
  count = var.event_target_arns["notify_core_sns_topic"] != null ? 1 : 0

  rule           = aws_cloudwatch_event_rule.template_events.name
  arn            = var.event_target_arns["notify_core_sns_topic"]
  target_id      = "notify-core-templates-queue"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name
  role_arn       = aws_iam_role.send_to_notify_core.0.arn
  input_path     = "$.detail"

  dead_letter_config {
    arn = module.notify_core_dlq.sqs_queue_arn
  }
}
