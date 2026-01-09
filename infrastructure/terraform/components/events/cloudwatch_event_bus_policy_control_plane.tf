resource "aws_cloudwatch_event_bus_policy" "control_plane_ingest" {
  policy         = data.aws_iam_policy_document.control_plane_ingest.json
  event_bus_name = aws_cloudwatch_event_bus.control_plane.name
}

data "aws_iam_policy_document" "control_plane_ingest" {
  statement {
    sid    = "AllowCrossAccountPutEvents"
    effect = "Allow"
    actions = [
      "events:PutEvents",
    ]

    resources = [
      aws_cloudwatch_event_bus.control_plane.arn
    ]

    principals {
      type = "AWS"
      identifiers = distinct(concat(
        formatlist("arn:aws:iam::%s:root", var.event_publisher_account_ids),
        var.template_control_cross_account_source != null ? ["arn:aws:iam::${var.template_control_cross_account_source.account_id}:root"] : []
      ))
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values = distinct(flatten([
        formatlist("arn:aws:iam::%s:role/comms-*-api-event-publisher", var.event_publisher_account_ids),
        formatlist("arn:aws:iam::%s:role/nhs-notify-*-eventpub", var.event_publisher_account_ids),
        (
          var.template_control_cross_account_source != null
          ) ? [
          "arn:aws:iam::${var.template_control_cross_account_source.account_id}:role/nhs-${var.template_control_cross_account_source.environment}-events-template-control-cross-account"
        ] : []
      ]))
    }
  }
}
