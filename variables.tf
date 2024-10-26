variable "region" {
  description = "Default AWS region"
  default     = "us-east-1"
}

variable "region_staging" {
  description = "AWS region for Staging"
  default     = "us-east-1"
}

variable "region_internal" {
  description = "AWS region for Internal"
  default     = "us-east-1"
}

variable "region_production" {
  description = "AWS region for Production"
  default     = "us-east-1"
}

variable "group_names" {
  description = "List of IAM groups"
  type        = list(string)
  default     = ["cs", "engineers", "sre", "growth"]
}

variable "environment" {
  description = "Environment (staging, internal, production)"
  type        = string
}
