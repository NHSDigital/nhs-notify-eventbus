resource "aws_cloudwatch_log_group" "control_plane" {
  name              = "/aws/vendedlogs/events/event-bus/${aws_cloudwatch_event_bus.control_plane.name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = module.kms.key_arn
}

resource "aws_cloudwatch_log_resource_policy" "control_plane" {
  policy_document = data.aws_iam_policy_document.control_plane.json
  policy_name     = "AWSLogDeliveryWrite-${aws_cloudwatch_event_bus.control_plane.name}"
}

data "aws_iam_policy_document" "control_plane" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.control_plane.arn}:log-stream:*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        aws_cloudwatch_log_delivery_source.control_plane_info_logs.arn,
        aws_cloudwatch_log_delivery_source.control_plane_error_logs.arn,
        aws_cloudwatch_log_delivery_source.control_plane_trace_logs.arn
      ]
    }
  }
}
