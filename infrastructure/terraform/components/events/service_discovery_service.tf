resource "aws_service_discovery_service" "main" {
  name = "${local.csi}-data-plane"

  namespace_id = aws_service_discovery_http_namespace.main.id

  health_check_custom_config {
    failure_threshold = 1
  }
}
