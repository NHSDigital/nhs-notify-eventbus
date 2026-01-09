locals {
  aws_lambda_functions_dir_path = "../../../../lambdas"
  group_suffix                  = element(split("-", var.group), -1)
}
