module "sqs_queue_control_plane_ingest" {
  source = "git::https://github.com/NHSDigital/nhs-notify-shared-modules.git//infrastructure/modules/sqs?ref=v1.0.4"

  aws_account_id = var.aws_account_id
  component      = var.component
  environment    = var.environment
  project        = var.project
  region         = var.region

  name                       = "${local.csi}-control-plane-ingest"
  sqs_kms_key_arn            = module.kms.key_arn
  message_retention_seconds  = 345600
  create_dlq                 = true
  visibility_timeout_seconds = 30

  default_tags = {
    function = "Control Plane Ingest"
  }
}
