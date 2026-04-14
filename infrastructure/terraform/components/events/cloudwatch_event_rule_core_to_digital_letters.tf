resource "aws_cloudwatch_event_rule" "core_to_digital_letters" {
  name           = "${local.csi}-core-to-digital-letters"
  description    = "Core events routed to Digital Letters"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        "uk.nhs.notify.channel.status.PUBLISHED.v1",
      ],
      "data" : {
        "supplierStatus" : [
          "paperletteroptedout"
        ]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "core_to_digital_letters" {
  count = var.event_target_arns["digital_letters_eventbus"] != null ? 1 : 0

  rule           = aws_cloudwatch_event_rule.core_to_digital_letters.name
  arn            = var.event_target_arns["digital_letters_eventbus"]
  target_id      = "core-to-digital-letters-eventbus"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
  role_arn       = aws_iam_role.core_to_digital_letters[0].arn
}

resource "aws_iam_role" "core_to_digital_letters" {
  count = var.event_target_arns["digital_letters_eventbus"] != null ? 1 : 0

  name = "${local.csi}-core-to-digital-letters"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "core_to_digital_letters" {
  count = var.event_target_arns["digital_letters_eventbus"] != null ? 1 : 0

  role = aws_iam_role.core_to_digital_letters[0].id

  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = "events:PutEvents"
      Resource = var.event_target_arns["digital_letters_eventbus"]
    }]
  })
}
