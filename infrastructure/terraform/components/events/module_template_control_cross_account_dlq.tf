module "template_control_cross_account_dlq" {
  count  = (var.template_control_cross_account_target != null) ? 1 : 0
  source = "https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.20/terraform-sqs.zip"

  aws_account_id  = var.aws_account_id
  component       = var.component
  environment     = var.environment
  project         = var.project
  region          = var.region
  name            = "template-control-cross-account-dlq"
  sqs_kms_key_arn = module.kms.key_arn

  sqs_policy_overload = data.aws_iam_policy_document.template_control_cross_account_dlq_allow_eventbridge[0].json
}

data "aws_iam_policy_document" "template_control_cross_account_dlq_allow_eventbridge" {
  count = (var.template_control_cross_account_target != null) ? 1 : 0

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [module.template_control_cross_account_dlq[0].sqs_queue_arn]
  }
}
