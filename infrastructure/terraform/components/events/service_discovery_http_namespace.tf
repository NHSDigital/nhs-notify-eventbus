resource "aws_service_discovery_http_namespace" "main" {
  name        = "${local.root_domain_name}"
  description = "${local.csi} Data Plane Service Namespace"
}
