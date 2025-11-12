module "core_to_supplier_events_dlq" {
  count = ( var.supplier_data_cross_account_target != null ) ? 1 : 0
  source = "https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.20/terraform-sqs.zip"

  aws_account_id  = var.aws_account_id
  component       = var.component
  environment     = var.environment
  project         = var.project
  region          = var.region
  name            = "core-to-supplier-events-dlq"
  sqs_kms_key_arn = module.kms.key_arn

  sqs_policy_overload = data.aws_iam_policy_document.core_to_supplier_events_allow_eventbridge[0].json
}

data "aws_iam_policy_document" "core_to_supplier_events_allow_eventbridge" {
  count = ( var.supplier_data_cross_account_target != null ) ? 1 : 0

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [module.core_to_supplier_events_dlq[0].sqs_queue_arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudwatch_event_rule.core_to_supplier[0].arn]
    }
  }
}
