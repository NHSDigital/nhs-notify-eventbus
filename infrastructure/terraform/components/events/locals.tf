locals {
  aws_lambda_functions_dir_path = "../../../../lambdas"
  group_suffix                  = element(split("-", var.group),-1)
  suppliers_api_sns_topic       = "arn:aws:sns:${var.region}:${var.supplier_data_cross_account_target.account_id}:nhs-${var.supplier_data_cross_account_target.environment}-supapi-eventsub"
}
