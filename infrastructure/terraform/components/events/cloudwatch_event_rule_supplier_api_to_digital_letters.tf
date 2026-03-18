resource "aws_cloudwatch_event_rule" "supplier_api_to_digital_letters" {
  name           = "${local.csi}-supplier-api-to-digital-letters"
  description    = "Supplier API events routed to Digital Letters"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name

  event_pattern = jsonencode({
    "detail" : {
      "type" : [
        { prefix = "uk.nhs.notify.supplier-api.letter.ACCEPTED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.CANCELLED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.DELIVERED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.DISPATCHED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.ENCLOSED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.FAILED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.FORWARDED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.PENDING" },
        { prefix = "uk.nhs.notify.supplier-api.letter.PRINTED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.REJECTED" },
        { prefix = "uk.nhs.notify.supplier-api.letter.RETURNED" }
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "supplier_api_to_digital_letters" {
  count = var.event_target_arns["digital_letters_eventbus"] != null ? 1 : 0

  rule           = aws_cloudwatch_event_rule.supplier_api_to_digital_letters.name
  arn            = var.event_target_arns["digital_letters_eventbus"]
  target_id      = "supplier-api-to-digital-letters-eventbus"
  event_bus_name = aws_cloudwatch_event_bus.data_plane.name
  role_arn       = aws_iam_role.supplier_api_to_digital_letters[0].arn
}

resource "aws_iam_role" "supplier_api_to_digital_letters" {
  count = var.event_target_arns["digital_letters_eventbus"] != null ? 1 : 0

  name = "eventbridge-cross-account"

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

resource "aws_iam_role_policy" "supplier_api_to_digital_letters" {
  count = var.event_target_arns["digital_letters_eventbus"] != null ? 1 : 0

  role = aws_iam_role.supplier_api_to_digital_letters[0].id

  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = "events:PutEvents"
      Resource = var.event_target_arns["digital_letters_eventbus"]
    }]
  })
}
