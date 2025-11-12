resource "aws_cloudwatch_event_rule" "core_to_supplier_api" {
  count = ( var.supplier_api_data_cross_account_target != null ) ? 1 : 0

  name           = "${local.csi}-core-to-supplier-api"
  description    = "Supplier API data events to Incoming Rule"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        {"prefix": "uk.nhs.notify.letter-rendering.letter-request.PREPARED"}
      ],
    }
  })
}

resource "aws_cloudwatch_event_target" "core_to_supplier_api_events" {
  count = ( var.supplier_api_data_cross_account_target != null ) ? 1 : 0

  rule           = aws_cloudwatch_event_rule.core_to_supplier_api[0].name
  arn            = local.supplier_api_sns_topic
  target_id      = "supplier-api-data-incoming"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
  role_arn       = aws_iam_role.core_to_supplier_api_events[0].arn
  dead_letter_config {
    arn = module.core_to_supplier_api_events_dlq[0].sqs_queue_arn
  }
}

data "aws_iam_policy_document" "core_to_supplier_api_events" {
  count = ( var.supplier_api_data_cross_account_target != null ) ? 1 : 0

  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "core_to_supplier_api_events" {
  count = ( var.supplier_api_data_cross_account_target != null ) ? 1 : 0

  name = "${local.csi}-core-to-supplier-api-events"

  assume_role_policy = data.aws_iam_policy_document.core_to_supplier_api_events[0].json
}

resource "aws_iam_policy" "core_to_supplier_api_events" {
  count = ( var.supplier_api_data_cross_account_target != null ) ? 1 : 0

  name = "${local.csi}-core-to-supplier-events"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sns:Publish",
      Resource = local.supplier_api_sns_topic
    },
    {
      Action = [
        "kms:GenerateDataKey",
        "kms:Encrypt",
        "kms:DescribeKey",
        "kms:Decrypt"
      ],
      Effect = "Allow",
      Resource = "arn:aws:kms:${var.region}:${var.supplier_api_data_cross_account_target.account_id}:key/*"
      Condition = {
        "ForAnyValue:StringEquals" = {
          "kms:ResourceAliases" = "alias/nhs-${var.supplier_api_data_cross_account_target.environment}-supapi"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "core_to_supplier_api_events" {
  count = ( var.supplier_api_data_cross_account_target != null ) ? 1 : 0

  role       = aws_iam_role.core_to_supplier_api_events[0].name
  policy_arn = aws_iam_policy.core_to_supplier_api_events[0].arn
}
