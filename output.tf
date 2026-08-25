# ---------------------------------------------------------
# Outputs
# ---------------------------------------------------------

output "step_function_name" {
  description = "Step Functions state machine name"
  value       = aws_sfn_state_machine.this.name
}

output "step_function_arn" {
  description = "Step Functions state machine ARN"
  value       = aws_sfn_state_machine.this.arn
}

output "step_function_role_arn" {
  description = "IAM role ARN used by Step Functions"
  value       = aws_iam_role.step_function_role.arn
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for Step Functions"
  value       = aws_cloudwatch_log_group.step_function_logs.name
}