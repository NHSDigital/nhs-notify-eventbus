resource "aws_iam_role" "send_to_notify_core_templates_queue" {
  count = can(var.event_target_arns["notify_core_templates_queue"]) ? 1 : 0

  name = "${local.csi}-templates-queue"

  assume_role_policy = data.aws_iam_policy_document.events_assumerole.0.json
}

data "aws_iam_policy_document" "events_assumerole" {
  count = can(var.event_target_arns["notify_core_templates_queue"]) ? 1 : 0

  statement {
    sid    = "EventsAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "events.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "send_to_notify_core_templates_queue" {
  count = can(var.event_target_arns["notify_core_templates_queue"]) ? 1 : 0

  name = "${local.csi}-templates-queue"
  role = aws_iam_role.send_to_notify_core_templates_queue.0.id

  policy = data.aws_iam_policy_document.send_to_notify_core_templates_queue.0.json
}

data "aws_iam_policy_document" "send_to_notify_core_templates_queue" {
  count = can(var.event_target_arns["notify_core_templates_queue"]) ? 1 : 0

  statement {
    sid    = "AllowSQS"
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    resources = flatten([
      var.event_target_arns["notify_core_templates_queue"],
      module.templates_dlq.sqs_queue_arn
    ])
  }

  statement {
    sid    = "AllowKmsUsage"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*"
    ]

    resources = [module.kms.key_arn, var.notify_core_sqs_kms_arn]
  }
}
