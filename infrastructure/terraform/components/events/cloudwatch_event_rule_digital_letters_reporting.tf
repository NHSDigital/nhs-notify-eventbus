resource "aws_cloudwatch_event_rule" "digital_letters_reporting" {
  name           = "${local.csi}-digital-letters-reporting"
  description    = "Digital Letters reporting events rule for inbound events"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        { prefix = "uk.nhs.notify.digital.letters." }
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "digital_letters_reporting" {
  count = (var.event_target_arns["reporting"] != null) && (var.reporting_data_cross_account_target != null) ? 1 : 0

  rule           = aws_cloudwatch_event_rule.digital_letters_reporting.name
  arn            = var.event_target_arns["reporting"]
  target_id      = "digital-letters-reporting"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
  role_arn       = aws_iam_role.digital_letters_reporting[0].arn
}

resource "aws_iam_role" "digital_letters_reporting" {
  count = (var.event_target_arns["reporting"] != null) && (var.reporting_data_cross_account_target != null) ? 1 : 0

  name = "${local.csi}-digital-letters-reporting"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "digital_letters_reporting" {
  count = (var.event_target_arns["reporting"] != null) && (var.reporting_data_cross_account_target != null) ? 1 : 0

  name = "${local.csi}-digital-letters-reporting-policy"

  role = aws_iam_role.digital_letters_reporting[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      # Action = [
      #   "firehose:PutRecord",
      #   "firehose:PutRecordBatch"
      # ]
      Action   = "SNS:Publish"
      Resource = var.event_target_arns["reporting"]
      },
      {
        Action = [
          "kms:GenerateDataKey",
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:Decrypt"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:kms:${var.region}:${var.reporting_data_cross_account_target.account_id}:key/*"
        Condition = {
          "ForAnyValue:StringEquals" = {
            "kms:ResourceAliases" = "alias/nhs-notify-${var.reporting_data_cross_account_target.environment}-reporting-s3"
          }
        }
    }]
  })
}
