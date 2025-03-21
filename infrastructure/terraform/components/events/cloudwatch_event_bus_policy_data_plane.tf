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

    principals {
      type        = "AWS"
      identifiers = var.delegated_event_publishing_roles
    }
  }
}

