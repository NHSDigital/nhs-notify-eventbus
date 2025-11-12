<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable -->
<!-- vale off -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.6 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID (numeric) | `string` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | The variable encapsulating the name of this component | `string` | `"events"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | A map of default tags to apply to all taggable resources within the component | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the tfscaffold environment | `string` | n/a | yes |
| <a name="input_event_publisher_account_ids"></a> [event\_publisher\_account\_ids](#input\_event\_publisher\_account\_ids) | An object representing account id's of event publishers | `list(any)` | `[]` | no |
| <a name="input_event_target_arns"></a> [event\_target\_arns](#input\_event\_target\_arns) | A map of event target ARNs keyed by name | <pre>object({<br/>    sms_nudge                               = string<br/>    notify_core_sns_topic                   = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_force_lambda_code_deploy"></a> [force\_lambda\_code\_deploy](#input\_force\_lambda\_code\_deploy) | If the lambda package in s3 has the same commit id tag as the terraform build branch, the lambda will not update automatically. Set to True if making changes to Lambda code from on the same commit for example during development | `bool` | `false` | no |
| <a name="input_group"></a> [group](#input\_group) | The group variables are being inherited from (often synonmous with account short-name) | `string` | n/a | yes |
| <a name="input_kms_deletion_window"></a> [kms\_deletion\_window](#input\_kms\_deletion\_window) | When a kms key is deleted, how long should it wait in the pending deletion state? | `string` | `"30"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | The log level to be used in lambda functions within the component. Any log with a lower severity than the configured value will not be logged: https://docs.python.org/3/library/logging.html#levels | `string` | `"INFO"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | The retention period in days for the Cloudwatch Logs events to be retained, default of 0 is indefinite | `number` | `0` | no |
| <a name="input_notify_core_sns_kms_arn"></a> [notify\_core\_sns\_kms\_arn](#input\_notify\_core\_sns\_kms\_arn) | Notify Core SNS KMS ARN | `string` | `null` | no |
| <a name="input_parent_acct_environment"></a> [parent\_acct\_environment](#input\_parent\_acct\_environment) | Name of the environment responsible for the acct resources used, affects things like DNS zone. Useful for named dev environments | `string` | `"main"` | no |
| <a name="input_project"></a> [project](#input\_project) | The name of the tfscaffold project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region | `string` | n/a | yes |
| <a name="input_supplier_api_data_cross_account_target"></a> [supplier\_api\_data\_cross\_account\_target](#input\_supplier\_api\_data\_cross\_account\_target) | Object containing environment and Account ID of the Supplier API Account to send Supplier Events | <pre>object({<br/>    environment = optional(string, null)<br/>    account_id  = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_template_control_cross_account_source"></a> [template\_control\_cross\_account\_source](#input\_template\_control\_cross\_account\_source) | Object containing environment and Account ID of the Control Plane Event Bus to allow Template Events FROM | <pre>object({<br/>    environment = optional(string, null)<br/>    account_id  = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_template_control_cross_account_target"></a> [template\_control\_cross\_account\_target](#input\_template\_control\_cross\_account\_target) | Object containing environment and Account ID of the Control Plane Event Bus to send Template Events TO | <pre>object({<br/>    environment = optional(string, null)<br/>    account_id  = optional(string, null)<br/>  })</pre> | `null` | no |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_core_to_supplier_api_events_dlq"></a> [core\_to\_supplier\_api\_events\_dlq](#module\_core\_to\_supplier\_api\_events\_dlq) | https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.20/terraform-sqs.zip | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.20/terraform-kms.zip | n/a |
| <a name="module_notify_core_dlq"></a> [notify\_core\_dlq](#module\_notify\_core\_dlq) | https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.20/terraform-sqs.zip | n/a |
| <a name="module_template_control_cross_account_dlq"></a> [template\_control\_cross\_account\_dlq](#module\_template\_control\_cross\_account\_dlq) | https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.20/terraform-sqs.zip | n/a |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_plane_event_bus"></a> [control\_plane\_event\_bus](#output\_control\_plane\_event\_bus) | n/a |
| <a name="output_data_plane_event_bus"></a> [data\_plane\_event\_bus](#output\_data\_plane\_event\_bus) | n/a |
<!-- vale on -->
<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->
