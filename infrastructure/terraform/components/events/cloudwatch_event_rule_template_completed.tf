resource "aws_cloudwatch_event_rule" "template_completed" {
  name           = "${local.csi}-template-completed"
  description    = "Event rule for inbound TemplateCompleted events"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        "uk.nhs.notify.template-management.TemplateCompleted.v1"
      ]
    },
    "source" : [{
      "wildcard" : "//notify.nhs.uk/app/*/${var.template_management_source_environment}",
    }]
  })
}

resource "aws_cloudwatch_event_target" "template_completed_notify_core_templates_queue" {
  count = length(try(event_target_arns["notify_core_templates_queue"], []))

  rule           = aws_cloudwatch_event_rule.template_completed.name
  arn            = var.event_target_arns["notify_core_templates_queue"][count.index]
  target_id      = "notify-core-templates-queue-${count.index}"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name
  role_arn       = aws_iam_role.send_to_notify_core_templates_queue.0.arn
  input_path     = "$.detail"

  dead_letter_config {
    arn = module.templates_dlq.sqs_queue_arn
  }
}
