variable "tenant_name" {
  description = "Naam van de tenant"
  type        = string
}

variable "project_names" {
  description = "Lijst van Harbor project namen"
  type        = list(string)
}

variable "owners" {
  description = "Lijst van usernames met Project Admin rol"
  type        = list(string)
  default     = []
}

variable "developers" {
  description = "Lijst van usernames met Developer rol"
  type        = list(string)
  default     = []
}
