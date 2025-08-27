module "notify_core_dlq" {
  source = "git::https://github.com/NHSDigital/nhs-notify-shared-modules.git//infrastructure/modules/sqs?ref=v2.0.8"

  aws_account_id  = var.aws_account_id
  component       = var.component
  environment     = var.environment
  project         = var.project
  region          = var.region
  name            = "notify-core-dlq"
  sqs_kms_key_arn = module.kms.key_arn

  sqs_policy_overload = data.aws_iam_policy_document.notify_core_dlq_allow_eventbridge.json
}

data "aws_iam_policy_document" "notify_core_dlq_allow_eventbridge" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [module.notify_core_dlq.sqs_queue_arn]
  }
}
