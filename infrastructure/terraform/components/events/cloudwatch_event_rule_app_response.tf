resource "aws_cloudwatch_event_rule" "app_response" {
  name           = "${local.csi}-app-response"
  description    = "App Response event rule for inbound events"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  ## The below is a dummy pattern. Schema to be defined.
  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        { "wildcard" : "uk.nhs.notify.app-response.*" },
      ],
      "dataschemaversion" : [{
        "prefix" : "1."
      }]
    }
  })
}

resource "aws_cloudwatch_event_target" "app_response" {
  rule           = aws_cloudwatch_event_rule.app_response.name
  arn            = var.event_target_arns["app_response"]
  target_id      = "app-response-events-target"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
  role_arn       = aws_iam_role.app_response.arn
}

data "aws_iam_policy_document" "app_response_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_response" {
  name = "${local.csi}-app-response"

  assume_role_policy = data.aws_iam_policy_document.app_response_assume_role.json
}

data "aws_iam_policy_document" "app_response_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [
      "arn:aws:sqs:eu-west-2:${var.supplier_api_data_cross_account_target.account_id}:nhs-${var.supplier_api_data_cross_account_target.environment}-response-request-inbound-event-queue",
    ]
  }
  statement {
    sid    = "AllowKmsUsage"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*"
    ]

    resources = [module.kms.key_arn, var.app_response_kms_key_arn]
  }
}

resource "aws_iam_policy" "app_response" {
  name = "${local.csi}-app-response"

  policy = data.aws_iam_policy_document.app_response_policy.json
}

resource "aws_iam_role_policy_attachment" "app_response" {
  role       = aws_iam_role.app_response.name
  policy_arn = aws_iam_policy.app_response.arn
}
