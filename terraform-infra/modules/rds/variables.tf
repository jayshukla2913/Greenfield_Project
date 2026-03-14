variable "private_subnets" {
  description = "Private subnets for RDS"
  type        = list(string)
}

variable "security_group" {
  description = "Security group for RDS"
  type        = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}