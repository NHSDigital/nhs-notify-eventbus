resource "aws_cloudwatch_event_bus" "data_plane" {
  name = "${local.csi}-data-plane"

  kms_key_identifier = module.kms.key_id
}

