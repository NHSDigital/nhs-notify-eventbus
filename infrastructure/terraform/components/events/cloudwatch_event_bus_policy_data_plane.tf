resource "aws_cloudwatch_event_bus_policy" "data_plane_ingest" {
  policy         = data.aws_iam_policy_document.data_plane_ingest.json
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
}

data "aws_iam_policy_document" "data_plane_ingest" {
  statement {
    sid    = "AllowCrossAccountPutEvents"
    effect = "Allow"
    actions = [
      "events:PutEvents",
    ]

    resources = [
      aws_cloudwatch_event_bus.data_plane.arn
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"

      values = [
        distinct(flatten([
          formatlist("arn:aws:iam::%s:role/comms-*-api-event-publisher", var.event_publisher_account_ids),
          formatlist("arn:aws:iam::%s:role/nhs-notify-*-eventpub", var.event_publisher_account_ids)
        ]))
      ]
    }
  }
}
