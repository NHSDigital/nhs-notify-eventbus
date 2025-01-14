resource "aws_cloudwatch_event_bus" "control_plane" {
  name = "${local.csi}-control-plane"

  kms_key_identifier = module.kms.key_id
}
