variable "tenant_name" {
  description = "Naam van de tenant"
  type        = string
}

variable "owners" {
  description = "Lijst van usernames met Owner rol"
  type        = list(string)
  default     = []
}

variable "developers" {
  description = "Lijst van usernames met Developer rol"
  type        = list(string)
  default     = []
}

variable "pos" {
  description = "Lijst van usernames met PO rol"
  type        = list(string)
  default     = []
}
