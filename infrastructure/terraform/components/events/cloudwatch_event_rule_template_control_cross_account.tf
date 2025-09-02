resource "aws_cloudwatch_event_rule" "template_control_cross_account" {
  count = ( var.template_control_cross_account_target != null ) ? 1 : 0

  name           = "${local.csi}-template-control-cross-account"
  description    = "Template Control events to Cross Account Eventbus"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        { "wildcard": "uk.nhs.notify.template-management.TemplateCompleted.*" },
        { "wildcard": "uk.nhs.notify.template-management.TemplateDrafted.*" },
        { "wildcard": "uk.nhs.notify.template-management.TemplateDeleted.*" }
      ]
      "source" : [
        "//notify.nhs.uk/app/nhs-notify-template-management-${local.group_suffix}/${var.environment}"
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "template_control_cross_account" {
  count = ( var.template_control_cross_account_target != null ) ? 1 : 0

  rule           = aws_cloudwatch_event_rule.template_control_cross_account[0].name
  arn            = "arn:aws:events:eu-west-2:${var.template_control_cross_account_target.account_id}:event-bus/nhs-${var.template_control_cross_account_target.environment}-events-control-plane"
  target_id      = "template-control-cross-account"
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name
  role_arn       = aws_iam_role.template_control_cross_account[0].arn
  dead_letter_config {
    arn = module.template_control_cross_account_dlq[0].sqs_queue_arn
  }
}

data "aws_iam_policy_document" "template_control_cross_account" {
  count = ( var.template_control_cross_account_target != null ) ? 1 : 0

  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "template_control_cross_account" {
  count = ( var.template_control_cross_account_target != null ) ? 1 : 0

  name = "${local.csi}-template-control-cross-account"

  assume_role_policy = data.aws_iam_policy_document.template_control_cross_account[0].json
}

resource "aws_iam_policy" "template_control_cross_account" {
  count = ( var.template_control_cross_account_target != null ) ? 1 : 0

  name = "${local.csi}-template-control-cross-account"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "events:PutEvents",
      Resource = "arn:aws:events:eu-west-2:${var.template_control_cross_account_target.account_id}:event-bus/nhs-${var.template_control_cross_account_target.environment}-events-control-plane"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "template_control_cross_account" {
  count = ( var.template_control_cross_account_target != null ) ? 1 : 0

  role       = aws_iam_role.template_control_cross_account[0].name
  policy_arn = aws_iam_policy.template_control_cross_account[0].arn
}
