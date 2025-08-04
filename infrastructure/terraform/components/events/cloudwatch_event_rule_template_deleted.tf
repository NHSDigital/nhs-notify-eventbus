resource "aws_cloudwatch_event_rule" "template_deleted" {
  name           = "${local.csi}-template-deleted"
  description    = "Event rule for inbound TemplateDeleted events"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name

  event_pattern = jsonencode({
    "detail": {
      "type": [
        "uk.nhs.notify.template-management.TemplateDeleted.v1"
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "template_deleted_notify_core_templates_queue" {
  rule           = aws_cloudwatch_event_rule.template_deleted.name
  arn            = var.event_target_arns["notify_core_templates_queue"]
  target_id      = "notify-core-templates-queue"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name
  role_arn       = aws_iam_role.send_to_notify_core_templates_queue.arn

  dead_letter_config {
    arn = module.templates_dlq.sqs_queue_arn
  }
}
