module "sqs_queue_data_plane_ingest" {
  source = "git::https://github.com/NHSDigital/nhs-notify-shared-modules.git//infrastructure/modules/sqs?ref=v1.0.5"

  aws_account_id = var.aws_account_id
  component      = var.component
  environment    = var.environment
  project        = var.project
  region         = var.region

  name                       = "data-plane-ingest"
  sqs_kms_key_arn            = module.kms.key_arn
  message_retention_seconds  = 345600
  create_dlq                 = true
  visibility_timeout_seconds = 30

  sqs_policy_overload = data.aws_iam_policy_document.sqs_data_plane_ingest.json

  default_tags = {
    function = "Data Plane Ingest"
  }
}

data "aws_iam_policy_document" "sqs_data_plane_ingest" {

  statement {
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    principals {
      type        = "AWS"
      identifiers = [for dep in var.delegated_data_event_publishers : lookup(dep, "publishing_role_arn",null)]
    }

    resources = [
      "arn:aws:sqs:${var.region}:${var.aws_account_id}:${local.csi}-data-plane-ingest-queue" # Build ARN to prevent circular-reference
    ]
  }
}
