# ---------------------------------------------------------
# Step Functions IAM Role
# ---------------------------------------------------------

resource "aws_iam_role" "step_function_role" {
  name = "${var.step_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "states.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

}

# ---------------------------------------------------------
# CloudWatch Log Group
# ---------------------------------------------------------

resource "aws_cloudwatch_log_group" "step_function_logs" {
  name              = "/aws/vendedlogs/states/${var.step_function_name}"
  retention_in_days = var.log_retention_days

}

# ---------------------------------------------------------
# IAM Policy for CloudWatch Logs
# ---------------------------------------------------------

resource "aws_iam_role_policy" "step_function_logging" {
  name = "${var.step_function_name}-logging-policy"
  role = aws_iam_role.step_function_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogDelivery",
          "logs:GetLogDelivery",
          "logs:UpdateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:ListLogDeliveries",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:DescribeLogGroups"
        ]

        Resource = "*"
      }
    ]
  })
}

# ---------------------------------------------------------
# Step Functions State Machine
# ---------------------------------------------------------

resource "aws_sfn_state_machine" "this" {
  name     = var.step_function_name
  role_arn = aws_iam_role.step_function_role.arn
  type     = var.step_function_type

  definition = jsonencode({
    Comment = "Test AWS Step Functions workflow"

    StartAt = "Start"

    States = {
      Start = {
        Type = "Pass"

        Result = {
          message = "Step Function execution started"
        }

        ResultPath = "$.start"

        Next = "Process"
      }

      Process = {
        Type = "Pass"

        Result = {
          message = "Processing completed successfully"
          status  = "SUCCESS"
        }

        ResultPath = "$.process"

        Next = "Success"
      }

      Success = {
        Type = "Succeed"
      }
    }
    }
  )
  # CloudWatch logging
  dynamic "logging_configuration" {
    for_each = var.enable_logging ? [1] : []

    content {
      log_destination        = "${aws_cloudwatch_log_group.step_function_logs.arn}:*"
      include_execution_data = var.include_execution_data
      level                  = var.log_level
    }
  }

  tracing_configuration {
    enabled = var.enable_xray
  }

  depends_on = [
    aws_iam_role_policy.step_function_logging
  ]
}