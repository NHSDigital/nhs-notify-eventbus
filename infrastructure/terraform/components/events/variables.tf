##
# Basic Required Variables for tfscaffold Components
##

variable "project" {
  type        = string
  description = "The name of the tfscaffold project"
}

variable "environment" {
  type        = string
  description = "The name of the tfscaffold environment"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS Account ID (numeric)"
}

variable "region" {
  type        = string
  description = "The AWS Region"
}

variable "group" {
  type        = string
  description = "The group variables are being inherited from (often synonmous with account short-name)"
}

##
# tfscaffold variables specific to this component
##

# This is the only primary variable to have its value defined as
# a default within its declaration in this file, because the variables
# purpose is as an identifier unique to this component, rather
# then to the environment from where all other variables come.
variable "component" {
  type        = string
  description = "The variable encapsulating the name of this component"
  default     = "events"
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to apply to all taggable resources within the component"
  default     = {}
}

##
# Variables specific to the "dnsroot"component
##

variable "kms_deletion_window" {
  type        = string
  description = "When a kms key is deleted, how long should it wait in the pending deletion state?"
  default     = "30"
}

variable "log_level" {
  type        = string
  description = "The log level to be used in lambda functions within the component. Any log with a lower severity than the configured value will not be logged: https://docs.python.org/3/library/logging.html#levels"
  default     = "INFO"
}

variable "log_retention_in_days" {
  type        = number
  description = "The retention period in days for the Cloudwatch Logs events to be retained, default of 0 is indefinite"
  default     = 0
}

variable "parent_acct_environment" {
  type        = string
  description = "Name of the environment responsible for the acct resources used, affects things like DNS zone. Useful for named dev environments"
  default     = "main"
}

variable "force_lambda_code_deploy" {
  type        = bool
  description = "If the lambda package in s3 has the same commit id tag as the terraform build branch, the lambda will not update automatically. Set to True if making changes to Lambda code from on the same commit for example during development"
  default     = false
}

variable "event_publisher_account_ids" {
  type        = list(any)
  description = "An object representing account id's of event publishers"
  default     = []
}

variable "event_target_arns" {
  description = "A map of event target ARNs keyed by name"
  type = object({
    sms_nudge                               = string
    notify_core_sns_topic                   = optional(string, null)
    supplier_api_sns_topic                  = optional(string, null)
    app_response                            = optional(string, null)
  })
}

variable "template_control_cross_account_target" {
  description = "Object containing environment and Account ID of the Control Plane Event Bus to send Template Events TO"
  type = object({
    environment = optional(string, null)
    account_id  = optional(string, null)
  })
  default = null
}

variable "template_control_cross_account_source" {
  description = "Object containing environment and Account ID of the Control Plane Event Bus to allow Template Events FROM"
  type = object({
    environment = optional(string, null)
    account_id  = optional(string, null)
  })
  default = null
}

variable "supplier_api_data_cross_account_target" {
  description = "Object containing environment and Account ID of the Supplier API Account to send Supplier Events"
  type = object({
    environment = optional(string, null)
    account_id  = optional(string, null)
  })
  default = null
}

variable "notify_core_sns_kms_arn" {
  description = "Notify Core SNS KMS ARN"
  type        = string
  default     = null
}
