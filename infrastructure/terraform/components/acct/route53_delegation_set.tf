resource "aws_route53_delegation_set" "main" {
  reference_name = "eventbus.${var.root_domain_name}"
}
