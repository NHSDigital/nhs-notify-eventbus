module "lambda_control_plane_validator" {
  source = "git::https://github.com/NHSDigital/nhs-notify-shared-modules.git//infrastructure/modules/lambda?ref=v1.0.4"

  function_name = "control-plane-validator"
  description   = "A function to validate incomming control plane events"

  aws_account_id = var.aws_account_id
  component      = var.component
  environment    = var.environment
  project        = var.project
  region         = var.region
  group          = var.group

  log_retention_in_days = var.log_retention_in_days
  kms_key_arn           = module.kms.key_arn

  iam_policy_document = {
    body = data.aws_iam_policy_document.lambda_control_plane_validator.json
  }

  function_s3_bucket      = local.acct.s3_buckets["lambda_function_artefacts"]["id"]
  function_code_base_path = local.aws_lambda_functions_dir_path
  function_code_dir       = "control-plane-validator/src"
  function_include_common = true
  function_module_name    = "index"
  handler_function_name   = "handler"
  runtime                 = "nodejs20.x"
  memory                  = 128
  timeout                 = 5
  log_level               = var.log_level

  force_lambda_code_deploy = var.force_lambda_code_deploy
  enable_lambda_insights   = true

  lambda_env_vars = {
    "EVENT_BUS_NAME" = aws_cloudwatch_event_bus.control_plane.name
    "DLQ_URL" = module.sqs_queue_control_plane_ingest.sqs_dlq_url
  }

}

data "aws_iam_policy_document" "lambda_control_plane_validator" {
  statement {
    sid    = "KMSPermissions"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]

    resources = [
      module.kms.key_arn,
    ]
  }

  statement {
    sid    = "SQSMessageQueue"
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]

    resources = [
      module.sqs_queue_control_plane_ingest.sqs_queue_arn,
    ]
  }

    statement {
    sid    = "EventBridgeBus"
    effect = "Allow"

    actions = [
      "events:PutEvents",
    ]

    resources = [
      aws_cloudwatch_event_bus.control_plane.arn,
    ]
  }
}

# Lambda Test Event
# {
#   "Records": [
#     {
#       "messageId": "19dd0b57-b21e-4ac1-bd88-01bbb068cb78",
#       "receiptHandle": "MessageReceiptHandle",
#       "body": "{\"message\":\"test\"}",
#       "attributes": {
#         "ApproximateReceiveCount": "1",
#         "SentTimestamp": "1523232000000",
#         "SenderId": "123456789012",
#         "ApproximateFirstReceiveTimestamp": "1523232000001"
#       },
#       "eventSource": "aws:sqs",
#       "eventSourceARN": "arn:aws:sqs:us-east-1:123456789012:MyQueue",
#       "awsRegion": "eu-west-2"
#     }
#   ]
# }
