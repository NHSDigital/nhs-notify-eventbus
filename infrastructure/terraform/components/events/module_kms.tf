module "kms" {
  source = "https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.20/terraform-kms.zip"

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }

  aws_account_id = var.aws_account_id
  component      = var.component
  environment    = var.environment
  project        = var.project
  region         = var.region

  name                 = "main"
  deletion_window      = var.kms_deletion_window
  alias                = "alias/${local.csi}"
  key_policy_documents = [data.aws_iam_policy_document.kms.json]
  iam_delegation       = true
}

data "aws_iam_policy_document" "kms" {
  # '*' resource scope is permitted in access policies as as the resource is itself
  # https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-services.html

  statement {
    sid    = "AllowCloudWatchEncrypt"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "logs.${var.region}.amazonaws.com",
        "events.amazonaws.com",
      ]
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = [
      "*",
    ]
  }

  dynamic "statement" {
    for_each = length(var.event_publisher_account_ids) > 0 ? [1] : []
    content {
      effect = "Allow"

      actions = ["kms:GenerateDataKey"]
      principals {
        type        = "AWS"
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
      resources = ["*"]
    }
  }
}
