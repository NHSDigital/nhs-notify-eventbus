module "templates_dlq" {
  source = "git::https://github.com/NHSDigital/nhs-notify-shared-modules.git//infrastructure/modules/sqs?ref=v2.0.8"

  aws_account_id  = var.aws_account_id
  component       = var.component
  environment     = var.environment
  project         = var.project
  region          = var.region
  name            = "templates-dlq"
  sqs_kms_key_arn = module.kms.key_arn

  sqs_policy_overload = data.aws_iam_policy_document.templates_dlq_allow_eventbridge.json
}

data "aws_iam_policy_document" "templates_dlq_allow_eventbridge" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [module.templates_dlq.sqs_queue_arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        aws_cloudwatch_event_bus.control_plane.arn
      ]
    }
  }
}
