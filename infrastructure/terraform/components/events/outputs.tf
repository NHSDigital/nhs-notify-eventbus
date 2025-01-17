output "service_discovery"{
  value = {
    data_plane_id    = aws_service_discovery_instance.data_plane.id
    control_pland_id = aws_service_discovery_instance.control_plane.id
    http_name        = aws_service_discovery_http_namespace.main.http_name
  }
}
