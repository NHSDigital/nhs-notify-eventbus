resource "aws_iam_role" "send_to_notify_core_templates_queue" {
  name = "EventBridgeToSQSRole"

  assume_role_policy = data.aws_iam_policy_document.events_assumerole.json
}

data "aws_iam_policy_document" "events_assumerole" {
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
  name = "AllowSQSSend"
  role = aws_iam_role.send_to_notify_core_templates_queue.id

  policy = data.aws_iam_policy_document.send_to_notify_core_templates_queue.json
}

data "aws_iam_policy_document" "send_to_notify_core_templates_queue" {
  statement {
    sid    = "AllowSQS"
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    resources = [
        var.event_target_arns["notify_core_templates_queue"]
    ]
  }
}
