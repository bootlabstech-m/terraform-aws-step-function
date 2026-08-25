variable "region" {
  description = "AWS region where Step Functions will be created"
  type        = string
}
variable "role_arn" {
  type        = string
  description = "role of the account."
}

variable "step_function_name" {
  description = "Name of the Step Functions state machine"
  type        = string
}

variable "step_function_type" {
  description = "Step Functions type STANDARD or EXPRESS"
  type        = string
  default     = "STANDARD"

}

variable "log_level" {
  description = "CloudWatch logging level must be ALL, ERROR, FATAL, or OFF."
  type        = string
  default     = "ALL"
}

variable "log_retention_days" {
  description = "CloudWatch log retention period"
  type        = number
  default     = 30
}

variable "enable_logging" {
  description = "Enable CloudWatch logging"
  type        = bool
  default     = false
}

variable "enable_xray" {
  description = "Enable X-Ray tracing"
  type        = bool
  default     = false
}

variable "include_execution_data" {
  description = "Include execution data in Step Functions CloudWatch logs"
  type        = bool
  default     = true
}
