<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable -->
<!-- vale off -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.6 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID (numeric) | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | The variable encapsulating the name of this component | `string` | `"events"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | A map of default tags to apply to all taggable resources within the component | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the tfscaffold environment | `string` | n/a | yes |
| <a name="input_event_publisher_account_ids"></a> [event\_publisher\_account\_ids](#input\_event\_publisher\_account\_ids) | An object representing account id's of event publishers | `list(any)` | `[]` | no |
| <a name="input_event_target_arns"></a> [event\_target\_arns](#input\_event\_target\_arns) | A map of event target ARNs keyed by name | `map(string)` | `{}` | no |
| <a name="input_force_lambda_code_deploy"></a> [force\_lambda\_code\_deploy](#input\_force\_lambda\_code\_deploy) | If the lambda package in s3 has the same commit id tag as the terraform build branch, the lambda will not update automatically. Set to True if making changes to Lambda code from on the same commit for example during development | `bool` | `false` | no |
| <a name="input_group"></a> [group](#input\_group) | The group variables are being inherited from (often synonmous with account short-name) | `string` | n/a | yes |
| <a name="input_kms_deletion_window"></a> [kms\_deletion\_window](#input\_kms\_deletion\_window) | When a kms key is deleted, how long should it wait in the pending deletion state? | `string` | `"30"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | The log level to be used in lambda functions within the component. Any log with a lower severity than the configured value will not be logged: https://docs.python.org/3/library/logging.html#levels | `string` | `"INFO"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | The retention period in days for the Cloudwatch Logs events to be retained, default of 0 is indefinite | `number` | `0` | no |
| <a name="input_notify_core_sqs_kms_arn"></a> [notify\_core\_sqs\_kms\_arn](#input\_notify\_core\_sqs\_kms\_arn) | Notify Core SQS KMS ARN | `string` | n/a | yes |
| <a name="input_parent_acct_environment"></a> [parent\_acct\_environment](#input\_parent\_acct\_environment) | Name of the environment responsible for the acct resources used, affects things like DNS zone. Useful for named dev environments | `string` | `"main"` | no |
| <a name="input_project"></a> [project](#input\_project) | The name of the tfscaffold project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region | `string` | n/a | yes |
| <a name="input_template_management_source_environment"></a> [template\_management\_source\_environment](#input\_template\_management\_source\_environment) | Template Management source environment | `string` | `"main"` | no |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | git::https://github.com/NHSDigital/nhs-notify-shared-modules.git//infrastructure/modules/kms | v1.0.8 |
| <a name="module_templates_dlq"></a> [templates\_dlq](#module\_templates\_dlq) | git::https://github.com/NHSDigital/nhs-notify-shared-modules.git//infrastructure/modules/sqs | v2.0.8 |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_plane_event_bus"></a> [control\_plane\_event\_bus](#output\_control\_plane\_event\_bus) | n/a |
| <a name="output_data_plane_event_bus"></a> [data\_plane\_event\_bus](#output\_data\_plane\_event\_bus) | n/a |
<!-- vale on -->
<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->
