resource "aws_iam_role" "send_to_notify_core" {
  count = var.event_target_arns["notify_core_sns_topic"] != null ? 1 : 0

  name = "${local.csi}-send-to-core"

  assume_role_policy = data.aws_iam_policy_document.events_assumerole.0.json
}

data "aws_iam_policy_document" "events_assumerole" {
  count = var.event_target_arns["notify_core_sns_topic"] != null ? 1 : 0

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

resource "aws_iam_role_policy" "send_to_notify_core" {
  count = var.event_target_arns["notify_core_sns_topic"] != null ? 1 : 0

  name = "${local.csi}-send-to-core"
  role = aws_iam_role.send_to_notify_core.0.id

  policy = data.aws_iam_policy_document.send_to_notify_core.0.json
}

data "aws_iam_policy_document" "send_to_notify_core" {
  count = var.event_target_arns["notify_core_sns_topic"] != null ? 1 : 0

  statement {
    sid    = "AllowSNS"
    effect = "Allow"

    actions = [
      "sns:Publish",
    ]

    resources = flatten([
      var.event_target_arns["notify_core_sns_topic"]
    ])
  }

  statement {
    sid    = "AllowSQS"
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    resources = flatten([
      module.notify_core_dlq.sqs_queue_arn
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

    resources = [module.kms.key_arn, var.notify_core_sns_kms_arn]
  }
}
