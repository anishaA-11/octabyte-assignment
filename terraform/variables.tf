variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM"
  type        = string
}

variable "db_username" {
  description = "Database admin username"
  type        = string
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}
